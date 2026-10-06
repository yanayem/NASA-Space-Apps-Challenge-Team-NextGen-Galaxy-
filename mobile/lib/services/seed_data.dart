import '../models/risk_models.dart';

class SeedData {
  static const List<CandidateSite> sampleSites = [
    CandidateSite(
      id: 'site_dhaka',
      name: 'Dhaka Central Logistics Hub',
      latitude: 23.8103,
      longitude: 90.4125,
      region: 'Dhaka Division, Bangladesh',
      description: 'High-density commercial transportation corridor with urban heat and drainage considerations.',
    ),
    CandidateSite(
      id: 'site_ctg',
      name: 'Chittagong Port Infrastructure Gateway',
      latitude: 22.3569,
      longitude: 91.7832,
      region: 'Chittagong Division, Bangladesh',
      description: 'Strategic maritime logistics coastal location subject to tidal water changes.',
    ),
    CandidateSite(
      id: 'site_gazipur',
      name: 'Gazipur Industrial Solar Park',
      latitude: 23.9999,
      longitude: 90.4203,
      region: 'Gazipur, Bangladesh',
      description: 'Expansive land area optimized for utility-scale solar generation with high surface thermal trends.',
    ),
    CandidateSite(
      id: 'site_sylhet',
      name: 'Sylhet Hi-Tech Data Center',
      latitude: 24.8949,
      longitude: 91.8687,
      region: 'Sylhet, Bangladesh',
      description: 'Elevated tech zone site with seasonal rainfall exposure and stable geotechnical profile.',
    ),
    CandidateSite(
      id: 'site_khulna',
      name: 'Khulna Eco-Industrial Site',
      latitude: 22.8456,
      longitude: 89.5403,
      region: 'Khulna, Bangladesh',
      description: 'Southern river basin industrial expansion zone with aquatic index monitoring.',
    ),
  ];

  static Map<String, dynamic> getRiskAnalysisDemo(String siteName, String projectType, double lat, double lon) {
    double score = 46.8;
    String riskLevel = "Moderate-Low Risk";
    
    if (projectType == 'solar_farm') {
      score = 38.2;
      riskLevel = "Low Risk";
    } else if (projectType == 'data_center') {
      score = 54.5;
      riskLevel = "Moderate Risk";
    } else if (projectType == 'factory') {
      score = 42.0;
      riskLevel = "Moderate-Low Risk";
    }

    return {
      "site_name": siteName,
      "location": {"latitude": lat, "longitude": lon},
      "project_type": projectType,
      "spacerisk_score": score,
      "risk_level": riskLevel,
      "sub_scores": {
        "flood_risk": 42.0,
        "heat_risk": 58.0,
        "env_change_risk": 40.0,
        "water_change_risk": 35.0,
        "thermal_event_risk": 25.0,
        "site_stability": 30.0
      },
      "project_adjusted_weights": {
        "flood": 0.35,
        "heat": 0.15,
        "env_change": 0.10,
        "water_change": 0.20,
        "thermal": 0.05,
        "stability": 0.15
      },
      "ai_investment_summary": "Target site evaluates to $score/100 ($riskLevel) for $projectType development. Multi-year NASA Earth-observation analysis reveals stable geotechnical land profiles accompanied by mild thermal expansion (+1.2°C over 6 years) and seasonal NDWI water fluctuations.",
      "actionable_mitigations": [
        "Elevate critical foundation level by at least +1.2m to guard against rising NDWI seasonal peaks.",
        "Incorporate cool roof coating and high solar reflectance index (SRI) materials to offset surface heat (LST).",
        "Implement retention basins & sustainable drainage systems (SuDS) to handle storm runoff during monsoon."
      ]
    };
  }

  static Map<String, dynamic> getSiteComparisonDemo(String projectType) {
    return {
      "project_type": projectType,
      "candidate_count": 3,
      "comparison_results": [
        {
          "site_name": "Dhaka Central Logistics Hub",
          "latitude": 23.8103,
          "longitude": 90.4125,
          "spacerisk_score": 42.5,
          "risk_level": "Moderate-Low Risk",
          "flood_risk": 38.0,
          "heat_risk": 58.0,
          "water_change": 32.0,
          "env_stability": 35.0,
          "key_recommendation": "Optimal logistics connectivity with moderate surface thermal mitigation required."
        },
        {
          "site_name": "Chittagong Port Infrastructure Gateway",
          "latitude": 22.3569,
          "longitude": 91.7832,
          "spacerisk_score": 58.2,
          "risk_level": "Moderate Risk",
          "flood_risk": 64.0,
          "heat_risk": 42.0,
          "water_change": 55.0,
          "env_stability": 40.0,
          "key_recommendation": "Requires elevated foundations and sea-surge storm barriers."
        },
        {
          "site_name": "Sylhet Hi-Tech Data Center",
          "latitude": 24.8949,
          "longitude": 91.8687,
          "spacerisk_score": 34.1,
          "risk_level": "Low Risk",
          "flood_risk": 28.0,
          "heat_risk": 32.0,
          "water_change": 22.0,
          "env_stability": 25.0,
          "key_recommendation": "Lowest overall risk profile with superior ground stability and cool thermal baselines."
        }
      ],
      "recommended_site": "Sylhet Hi-Tech Data Center",
      "comparison_summary": "SpaceRisk AI recommends 'Sylhet Hi-Tech Data Center' as the premier low-risk choice for $projectType development. It exhibits superior multi-year environmental stability (34.1/100) compared to coastal or urban core sites."
    };
  }

  static Map<String, dynamic> getIndicatorsDemo(double lat, double lon) {
    return {
      "location": {
        "latitude": lat,
        "longitude": lon,
        "region": "Bangladesh Focus Zone"
      },
      "period": "2018-2024",
      "indicators": [
        {"year": 2018, "ndvi": 0.55, "ndwi": -0.12, "ndbi": 0.15, "lst_celsius": 29.8, "thermal_anomalies": 2},
        {"year": 2019, "ndvi": 0.52, "ndwi": -0.10, "ndbi": 0.18, "lst_celsius": 30.2, "thermal_anomalies": 3},
        {"year": 2020, "ndvi": 0.48, "ndwi": -0.07, "ndbi": 0.22, "lst_celsius": 30.8, "thermal_anomalies": 4},
        {"year": 2021, "ndvi": 0.45, "ndwi": -0.04, "ndbi": 0.26, "lst_celsius": 31.1, "thermal_anomalies": 4},
        {"year": 2022, "ndvi": 0.41, "ndwi": -0.01, "ndbi": 0.31, "lst_celsius": 31.6, "thermal_anomalies": 6},
        {"year": 2023, "ndvi": 0.38, "ndwi": 0.02, "ndbi": 0.35, "lst_celsius": 32.2, "thermal_anomalies": 7},
        {"year": 2024, "ndvi": 0.35, "ndwi": 0.05, "ndbi": 0.39, "lst_celsius": 32.7, "thermal_anomalies": 8}
      ],
      "summary": "Multi-year NASA satellite observations reveal rapid built-up area growth (+160% NDBI increase from 2018 to 2024) accompanied by a gradual decline in vegetation canopy (NDVI) and a +2.9°C increase in surface land temperature (LST)."
    };
  }

  static Map<String, dynamic> getApodDemo() {
    return {
      "title": "Earth at Night & NASA Earth Observation Constellation",
      "explanation": "NASA satellites including Landsat 8/9, Sentinel, MODIS, and VIIRS provide continuous remote sensing monitoring of planet Earth. This satellite data powers risk intelligence, climate change modeling, and infrastructure disaster mitigation globally.",
      "url": "https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=1000&auto=format&fit=crop",
      "hdurl": "https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2000&auto=format&fit=crop",
      "date": "2026-03-30",
      "media_type": "image"
    };
  }

  static Map<String, dynamic> getReportDemo(String siteName, String projectType) {
    return {
      "report_id": "SR-RPT-8F3A2B",
      "site_name": siteName,
      "generated_at": "2026-03-30 14:30:00 UTC",
      "download_url": "https://spacerisk.onrender.com/api/reports/download/8f3a2b/",
      "summary": "Executive B2B SpaceRisk Assessment PDF generated successfully for $siteName ($projectType). Includes multi-year Earth observation trend analysis, flood & heat vulnerability breakdowns, and actionable engineering mitigations."
    };
  }
}
