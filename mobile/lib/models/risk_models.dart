class CandidateSite {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String region;
  final String description;

  const CandidateSite({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.description,
  });

  factory CandidateSite.fromJson(Map<String, dynamic> json) {
    return CandidateSite(
      id: json['id'] ?? '',
      name: json['name'] ?? json['site_name'] ?? 'Candidate Site',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      region: json['region'] ?? 'Focus Region',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'region': region,
        'description': description,
      };
}

class SubRiskBreakdown {
  final double floodRisk;
  final double heatRisk;
  final double envChangeRisk;
  final double waterChangeRisk;
  final double thermalEventRisk;
  final double siteStability;

  const SubRiskBreakdown({
    required this.floodRisk,
    required this.heatRisk,
    required this.envChangeRisk,
    required this.waterChangeRisk,
    required this.thermalEventRisk,
    required this.siteStability,
  });

  factory SubRiskBreakdown.fromJson(Map<String, dynamic> json) {
    return SubRiskBreakdown(
      floodRisk: (json['flood_risk'] as num?)?.toDouble() ?? 0.0,
      heatRisk: (json['heat_risk'] as num?)?.toDouble() ?? 0.0,
      envChangeRisk: (json['env_change_risk'] as num?)?.toDouble() ?? 0.0,
      waterChangeRisk: (json['water_change_risk'] as num?)?.toDouble() ?? 0.0,
      thermalEventRisk: (json['thermal_event_risk'] as num?)?.toDouble() ?? 0.0,
      siteStability: (json['site_stability'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'flood_risk': floodRisk,
        'heat_risk': heatRisk,
        'env_change_risk': envChangeRisk,
        'water_change_risk': waterChangeRisk,
        'thermal_event_risk': thermalEventRisk,
        'site_stability': siteStability,
      };
}

class RiskAnalysisResult {
  final String siteName;
  final double latitude;
  final double longitude;
  final String projectType;
  final double spaceRiskScore;
  final String riskLevel;
  final SubRiskBreakdown subScores;
  final Map<String, double> projectAdjustedWeights;
  final String aiInvestmentSummary;
  final List<String> actionableMitigations;

  const RiskAnalysisResult({
    required this.siteName,
    required this.latitude,
    required this.longitude,
    required this.projectType,
    required this.spaceRiskScore,
    required this.riskLevel,
    required this.subScores,
    required this.projectAdjustedWeights,
    required this.aiInvestmentSummary,
    required this.actionableMitigations,
  });

  factory RiskAnalysisResult.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>? ?? {};
    final rawWeights = json['project_adjusted_weights'] as Map<String, dynamic>? ?? {};
    
    Map<String, double> parsedWeights = {};
    rawWeights.forEach((key, value) {
      parsedWeights[key] = (value as num).toDouble();
    });

    return RiskAnalysisResult(
      siteName: json['site_name'] ?? 'Candidate Site',
      latitude: (loc['latitude'] as num?)?.toDouble() ?? 23.8103,
      longitude: (loc['longitude'] as num?)?.toDouble() ?? 90.4125,
      projectType: json['project_type'] ?? 'warehouse',
      spaceRiskScore: (json['spacerisk_score'] as num?)?.toDouble() ?? 0.0,
      riskLevel: json['risk_level'] ?? 'Unknown Risk',
      subScores: SubRiskBreakdown.fromJson(json['sub_scores'] ?? {}),
      projectAdjustedWeights: parsedWeights,
      aiInvestmentSummary: json['ai_investment_summary'] ?? '',
      actionableMitigations: List<String>.from(json['actionable_mitigations'] ?? []),
    );
  }
}

class SiteComparisonItem {
  final String siteName;
  final double latitude;
  final double longitude;
  final double spaceRiskScore;
  final String riskLevel;
  final double floodRisk;
  final double heatRisk;
  final double waterChange;
  final double envStability;
  final String keyRecommendation;

  const SiteComparisonItem({
    required this.siteName,
    required this.latitude,
    required this.longitude,
    required this.spaceRiskScore,
    required this.riskLevel,
    required this.floodRisk,
    required this.heatRisk,
    required this.waterChange,
    required this.envStability,
    required this.keyRecommendation,
  });

  factory SiteComparisonItem.fromJson(Map<String, dynamic> json) {
    return SiteComparisonItem(
      siteName: json['site_name'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      spaceRiskScore: (json['spacerisk_score'] as num?)?.toDouble() ?? 0.0,
      riskLevel: json['risk_level'] ?? '',
      floodRisk: (json['flood_risk'] as num?)?.toDouble() ?? 0.0,
      heatRisk: (json['heat_risk'] as num?)?.toDouble() ?? 0.0,
      waterChange: (json['water_change'] as num?)?.toDouble() ?? 0.0,
      envStability: (json['env_stability'] as num?)?.toDouble() ?? 0.0,
      keyRecommendation: json['key_recommendation'] ?? '',
    );
  }
}

class SiteComparisonResponse {
  final String projectType;
  final int candidateCount;
  final List<SiteComparisonItem> comparisonResults;
  final String recommendedSite;
  final String comparisonSummary;

  const SiteComparisonResponse({
    required this.projectType,
    required this.candidateCount,
    required this.comparisonResults,
    required this.recommendedSite,
    required this.comparisonSummary,
  });

  factory SiteComparisonResponse.fromJson(Map<String, dynamic> json) {
    var rawList = json['comparison_results'] as List? ?? [];
    List<SiteComparisonItem> items =
        rawList.map((e) => SiteComparisonItem.fromJson(e)).toList();

    return SiteComparisonResponse(
      projectType: json['project_type'] ?? 'warehouse',
      candidateCount: json['candidate_count'] ?? items.length,
      comparisonResults: items,
      recommendedSite: json['recommended_site'] ?? '',
      comparisonSummary: json['comparison_summary'] ?? '',
    );
  }
}

class IndicatorTrendItem {
  final int year;
  final double ndvi;
  final double ndwi;
  final double ndbi;
  final double lstCelsius;
  final int thermalAnomalies;

  const IndicatorTrendItem({
    required this.year,
    required this.ndvi,
    required this.ndwi,
    required this.ndbi,
    required this.lstCelsius,
    required this.thermalAnomalies,
  });

  factory IndicatorTrendItem.fromJson(Map<String, dynamic> json) {
    return IndicatorTrendItem(
      year: json['year'] ?? 2020,
      ndvi: (json['ndvi'] as num?)?.toDouble() ?? 0.0,
      ndwi: (json['ndwi'] as num?)?.toDouble() ?? 0.0,
      ndbi: (json['ndbi'] as num?)?.toDouble() ?? 0.0,
      lstCelsius: (json['lst_celsius'] as num?)?.toDouble() ?? 0.0,
      thermalAnomalies: json['thermal_anomalies'] ?? 0,
    );
  }
}

class IndicatorResponse {
  final double latitude;
  final double longitude;
  final String region;
  final String period;
  final List<IndicatorTrendItem> indicators;
  final String summary;

  const IndicatorResponse({
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.period,
    required this.indicators,
    required this.summary,
  });

  factory IndicatorResponse.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] as Map<String, dynamic>? ?? {};
    var rawItems = json['indicators'] as List? ?? [];
    List<IndicatorTrendItem> items =
        rawItems.map((e) => IndicatorTrendItem.fromJson(e)).toList();

    return IndicatorResponse(
      latitude: (loc['latitude'] as num?)?.toDouble() ?? 23.8103,
      longitude: (loc['longitude'] as num?)?.toDouble() ?? 90.4125,
      region: loc['region'] ?? 'Target Zone',
      period: json['period'] ?? '2018-2024',
      indicators: items,
      summary: json['summary'] ?? '',
    );
  }
}

class ExecutiveReport {
  final String reportId;
  final String siteName;
  final String generatedAt;
  final String downloadUrl;
  final String summary;

  const ExecutiveReport({
    required this.reportId,
    required this.siteName,
    required this.generatedAt,
    required this.downloadUrl,
    required this.summary,
  });

  factory ExecutiveReport.fromJson(Map<String, dynamic> json) {
    return ExecutiveReport(
      reportId: json['report_id'] ?? 'SR-RPT-0001',
      siteName: json['site_name'] ?? 'Candidate Site',
      generatedAt: json['generated_at'] ?? '',
      downloadUrl: json['download_url'] ?? '',
      summary: json['summary'] ?? '',
    );
  }
}

class ApodData {
  final String title;
  final String explanation;
  final String url;
  final String? hdurl;
  final String date;
  final String mediaType;

  const ApodData({
    required this.title,
    required this.explanation,
    required this.url,
    this.hdurl,
    required this.date,
    required this.mediaType,
  });

  factory ApodData.fromJson(Map<String, dynamic> json) {
    return ApodData(
      title: json['title'] ?? 'Astronomy Picture of the Day',
      explanation: json['explanation'] ?? '',
      url: json['url'] ?? '',
      hdurl: json['hdurl'],
      date: json['date'] ?? '',
      mediaType: json['media_type'] ?? 'image',
    );
  }
}
