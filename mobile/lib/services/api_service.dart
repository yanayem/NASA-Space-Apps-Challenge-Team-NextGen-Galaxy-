import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/risk_models.dart';
import 'seed_data.dart';

class ApiService extends ChangeNotifier {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Backend URL (Default to local IP or localhost)
  String _backendUrl = 'http://192.168.0.163:8000/api';
  bool _useSeedDataMode = false;
  bool _lastRequestWasDemo = false;

  String get backendUrl => _backendUrl;
  bool get useSeedDataMode => _useSeedDataMode;
  bool get lastRequestWasDemo => _lastRequestWasDemo;

  void setBackendUrl(String url) {
    _backendUrl = url.trim().replaceAll(RegExp(r'/$'), '');
    notifyListeners();
  }

  void setSeedDataMode(bool enabled) {
    _useSeedDataMode = enabled;
    notifyListeners();
  }

  Future<bool> checkHealth() async {
    if (_useSeedDataMode) {
      _lastRequestWasDemo = true;
      notifyListeners();
      return true;
    }
    try {
      final response = await http
          .get(Uri.parse('$_backendUrl/health/'))
          .timeout(const Duration(seconds: 4));
      _lastRequestWasDemo = false;
      notifyListeners();
      return response.statusCode == 200;
    } catch (e) {
      _lastRequestWasDemo = true;
      notifyListeners();
      return false;
    }
  }

  Future<RiskAnalysisResult> evaluateSiteRisk({
    required String siteName,
    required String projectType,
    required double latitude,
    required double longitude,
  }) async {
    if (_useSeedDataMode) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getRiskAnalysisDemo(siteName, projectType, latitude, longitude);
      return RiskAnalysisResult.fromJson(demo);
    }

    try {
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
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _lastRequestWasDemo = false;
        notifyListeners();
        final body = json.decode(response.body);
        return RiskAnalysisResult.fromJson(body);
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to seed data seamlessly
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getRiskAnalysisDemo(siteName, projectType, latitude, longitude);
      return RiskAnalysisResult.fromJson(demo);
    }
  }

  Future<SiteComparisonResponse> compareSites({
    required String projectType,
    required List<CandidateSite> sites,
  }) async {
    if (_useSeedDataMode) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getSiteComparisonDemo(projectType);
      return SiteComparisonResponse.fromJson(demo);
    }

    try {
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
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _lastRequestWasDemo = false;
        notifyListeners();
        final body = json.decode(response.body);
        return SiteComparisonResponse.fromJson(body);
      } else {
        throw Exception('Server status ${response.statusCode}');
      }
    } catch (e) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getSiteComparisonDemo(projectType);
      return SiteComparisonResponse.fromJson(demo);
    }
  }

  Future<IndicatorResponse> fetchIndicators({
    required double latitude,
    required double longitude,
    int startYear = 2018,
    int endYear = 2024,
  }) async {
    if (_useSeedDataMode) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getIndicatorsDemo(latitude, longitude);
      return IndicatorResponse.fromJson(demo);
    }

    try {
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
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _lastRequestWasDemo = false;
        notifyListeners();
        final body = json.decode(response.body);
        return IndicatorResponse.fromJson(body);
      } else {
        throw Exception('Server status ${response.statusCode}');
      }
    } catch (e) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getIndicatorsDemo(latitude, longitude);
      return IndicatorResponse.fromJson(demo);
    }
  }

  Future<ExecutiveReport> generateReport({
    required String siteName,
    required String projectType,
    required double latitude,
    required double longitude,
  }) async {
    if (_useSeedDataMode) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getReportDemo(siteName, projectType);
      return ExecutiveReport.fromJson(demo);
    }

    try {
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
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _lastRequestWasDemo = false;
        notifyListeners();
        final body = json.decode(response.body);
        return ExecutiveReport.fromJson(body);
      } else {
        throw Exception('Server status ${response.statusCode}');
      }
    } catch (e) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getReportDemo(siteName, projectType);
      return ExecutiveReport.fromJson(demo);
    }
  }

  Future<ApodData> fetchApod() async {
    if (_useSeedDataMode) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getApodDemo();
      return ApodData.fromJson(demo);
    }

    try {
      final response = await http
          .get(Uri.parse('$_backendUrl/apod/'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _lastRequestWasDemo = false;
        notifyListeners();
        final body = json.decode(response.body);
        return ApodData.fromJson(body);
      } else {
        throw Exception('Server status ${response.statusCode}');
      }
    } catch (e) {
      _lastRequestWasDemo = true;
      notifyListeners();
      final demo = SeedData.getApodDemo();
      return ApodData.fromJson(demo);
    }
  }
}
