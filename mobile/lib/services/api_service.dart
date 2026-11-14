import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/risk_models.dart';

class ApiService extends ChangeNotifier {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Backend URL (Default to live Render cloud backend)
  String _backendUrl = 'https://spacerisk.onrender.com/api';
  String _nasaApiKey = 'NWr68pbWkjfcNfNNk8WDhfzhCJMWBCHH8MkkBhKM';
  String _tempUnit = 'Celsius (°C)';
  String _windUnit = 'km/h';
  String _climateHorizon = '2040 Decadal Projection';

  String get backendUrl => _backendUrl;
  String get nasaApiKey => _nasaApiKey;
  String get tempUnit => _tempUnit;
  String get windUnit => _windUnit;
  String get climateHorizon => _climateHorizon;

  void setBackendUrl(String url) {
    _backendUrl = url.trim().replaceAll(RegExp(r'/$'), '');
    notifyListeners();
  }

  void setNasaApiKey(String key) {
    _nasaApiKey = key.trim();
    notifyListeners();
  }

  void setPreferences({
    String? tempUnit,
    String? windUnit,
    String? climateHorizon,
  }) {
    if (tempUnit != null) _tempUnit = tempUnit;
    if (windUnit != null) _windUnit = windUnit;
    if (climateHorizon != null) _climateHorizon = climateHorizon;
    notifyListeners();
  }

  void resetToDefaults() {
    _backendUrl = 'https://spacerisk.onrender.com/api';
    _nasaApiKey = 'NWr68pbWkjfcNfNNk8WDhfzhCJMWBCHH8MkkBhKM';
    _tempUnit = 'Celsius (°C)';
    _windUnit = 'km/h';
    _climateHorizon = '2040 Decadal Projection';
    notifyListeners();
  }

  /// Automatically tests if local backend (10.0.2.2 / 127.0.0.1) is running;
  /// if active, connects locally; otherwise defaults to live Render cloud.
  Future<String> autoDetectBestBackend() async {
    final candidates = [
      'http://10.0.2.2:8000/api',
      'http://127.0.0.1:8000/api',
      'https://spacerisk.onrender.com/api',
    ];

    for (final url in candidates) {
      try {
        final resp = await http
            .get(Uri.parse('$url/health/'))
            .timeout(const Duration(milliseconds: 1500));
        if (resp.statusCode == 200) {
          _backendUrl = url;
          notifyListeners();
          return url;
        }
      } catch (_) {}
    }
    _backendUrl = 'https://spacerisk.onrender.com/api';
    notifyListeners();
    return _backendUrl;
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$_backendUrl/health/'))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) return true;
    } catch (_) {}

    // Smart auto-detection fallback if current backend URL is unreachable
    final activeUrl = await autoDetectBestBackend();
    try {
      final response = await http
          .get(Uri.parse('$activeUrl/health/'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<RiskAnalysisResult> evaluateSiteRisk({
    required String siteName,
    required String projectType,
    required double latitude,
    required double longitude,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_backendUrl/risk-analysis/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'site_name': siteName,
            'project_type': projectType,
            'latitude': latitude,
            'longitude': longitude,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return RiskAnalysisResult.fromJson(body);
    } else {
      throw Exception('Server returned ${response.statusCode}');
    }
  }

  Future<SiteComparisonResponse> compareSites({
    required String projectType,
    required List<CandidateSite> sites,
  }) async {
    final locations = sites
        .map((s) => {
              'site_name': s.name,
              'latitude': s.latitude,
              'longitude': s.longitude,
            })
        .toList();

    final response = await http
        .post(
          Uri.parse('$_backendUrl/site-comparison/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'project_type': projectType,
            'locations': locations,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return SiteComparisonResponse.fromJson(body);
    } else {
      throw Exception('Server returned ${response.statusCode}');
    }
  }

  Future<IndicatorResponse> fetchIndicators({
    required double latitude,
    required double longitude,
    int startYear = 2018,
    int endYear = 2024,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_backendUrl/indicators/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'latitude': latitude,
            'longitude': longitude,
            'start_year': startYear,
            'end_year': endYear,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return IndicatorResponse.fromJson(body);
    } else {
      throw Exception('Server returned ${response.statusCode}');
    }
  }

  Future<ExecutiveReport> generateReport({
    required String siteName,
    required String projectType,
    required double latitude,
    required double longitude,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_backendUrl/reports/generate/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'site_name': siteName,
            'project_type': projectType,
            'latitude': latitude,
            'longitude': longitude,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return ExecutiveReport.fromJson(body);
    } else {
      throw Exception('Server returned ${response.statusCode}');
    }
  }

  Future<ApodData> fetchApod({String? date}) async {
    Uri uri = Uri.parse('$_backendUrl/apod/');
    if (date != null && date.isNotEmpty) {
      uri = uri.replace(queryParameters: {'date': date});
    }

    // Attempt 1: Fetch via SpaceRisk Backend Proxy
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return ApodData.fromJson(body);
      }
    } catch (_) {}

    // Attempt 2: Direct query to official NASA API (Primary Key)
    try {
      String nasaUrl = 'https://api.nasa.gov/planetary/apod?api_key=$_nasaApiKey';
      if (date != null && date.isNotEmpty) {
        nasaUrl += '&date=$date';
      }
      var directResp = await http.get(Uri.parse(nasaUrl)).timeout(const Duration(seconds: 8));

      // Attempt 3: Retry NASA API with DEMO_KEY
      if (directResp.statusCode != 200 && _nasaApiKey != 'DEMO_KEY') {
        String demoUrl = 'https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY';
        if (date != null && date.isNotEmpty) {
          demoUrl += '&date=$date';
        }
        directResp = await http.get(Uri.parse(demoUrl)).timeout(const Duration(seconds: 8));
      }

      if (directResp.statusCode == 200) {
        final body = json.decode(directResp.body);
        return ApodData.fromJson(body);
      }
    } catch (_) {}

    // Attempt 4: Guaranteed curated NASA APOD fallback dataset
    return const ApodData(
      title: 'Earth Observation: Blue Marble & Global Spectral Telemetry',
      explanation:
          'High-resolution satellite view of Earth captured by NASA Earth-observing constellations. SpaceRisk processes spectral indices (NDVI, NDWI, LST) from NASA HLS & Landsat-9 mission datasets for global multi-hazard climate risk evaluation.',
      url: 'https://images-assets.nasa.gov/image/PIA18033/PIA18033~orig.jpg',
      hdurl: 'https://images-assets.nasa.gov/image/PIA18033/PIA18033~orig.jpg',
      date: 'NASA Feed',
      mediaType: 'image',
    );
  }
}
