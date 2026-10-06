import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/seed_data.dart';
import '../models/risk_models.dart';
import '../widgets/risk_gauge.dart';

class SiteRiskScreen extends StatefulWidget {
  const SiteRiskScreen({super.key});

  @override
  State<SiteRiskScreen> createState() => _SiteRiskScreenState();
}

class _SiteRiskScreenState extends State<SiteRiskScreen> {
  final ApiService _apiService = ApiService();

  CandidateSite _selectedSite = SeedData.sampleSites[0];
  String _projectType = 'warehouse';
  bool _isLoading = false;
  RiskAnalysisResult? _analysisResult;

  final Map<String, String> _projectTypes = {
    'warehouse': 'Warehouse / Logistics Hub',
    'factory': 'Industrial Factory',
    'solar_farm': 'Solar Power Farm',
    'telecom_tower': 'Telecom Infrastructure Tower',
    'data_center': 'Data Center Facility',
    'commercial': 'Commercial Complex',
    'residential': 'Residential Development',
  };

  @override
  void initState() {
    super.initState();
    _evaluateRisk();
  }

  Future<void> _evaluateRisk() async {
    setState(() => _isLoading = true);
    try {
      final res = await _apiService.evaluateSiteRisk(
        siteName: _selectedSite.name,
        projectType: _projectType,
        latitude: _selectedSite.latitude,
        longitude: _selectedSite.longitude,
      );
      if (mounted) {
        setState(() {
          _analysisResult = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Form Card
          _buildSelectionCard(),
          const SizedBox(height: 20),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Processing Earth-Observation Satellite Metrics...',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else if (_analysisResult != null) ...[
            // Main Gauge & Overall Score Section
            _buildGaugeCard(_analysisResult!),
            const SizedBox(height: 16),

            // AI Investment Summary
            _buildAiSummaryCard(_analysisResult!),
            const SizedBox(height: 16),

            // Sub-Risk Breakdown Metrics
            _buildSubRiskBreakdownCard(_analysisResult!),
            const SizedBox(height: 16),

            // Actionable Engineering Mitigations
            _buildMitigationsCard(_analysisResult!),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151921),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222938)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune, color: Color(0xFF3B82F6), size: 20),
              SizedBox(width: 8),
              Text(
                'Target Candidate Site & Project Parameters',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Candidate Site Selector
          const Text('Select Target Site:', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0E14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF222938)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CandidateSite>(
                value: _selectedSite,
                isExpanded: true,
                dropdownColor: const Color(0xFF151921),
                items: SeedData.sampleSites.map((site) {
                  return DropdownMenuItem<CandidateSite>(
                    value: site,
                    child: Text(
                      site.name,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedSite = val;
                    });
                    _evaluateRisk();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Infrastructure Project Type
          const Text('Infrastructure Project Type:', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0E14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF222938)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _projectType,
                isExpanded: true,
                dropdownColor: const Color(0xFF151921),
                items: _projectTypes.entries.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.key,
                    child: Text(
                      e.value,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _projectType = val;
                    });
                    _evaluateRisk();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeCard(RiskAnalysisResult result) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF151921),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF222938)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.siteName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Coords: (${result.latitude}, ${result.longitude})',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(
                  _projectTypes[result.projectType] ?? result.projectType,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF222938),
              ),
            ],
          ),
          const SizedBox(height: 20),
          RiskGaugeWidget(
            score: result.spaceRiskScore,
            riskLevel: result.riskLevel,
            size: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildAiSummaryCard(RiskAnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Color(0xFF3B82F6), size: 20),
              SizedBox(width: 8),
              Text(
                'AI Investment & Site Recommendation',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            result.aiInvestmentSummary,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.87),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubRiskBreakdownCard(RiskAnalysisResult result) {
    final sub = result.subScores;
    final w = result.projectAdjustedWeights;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151921),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222938)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sub-Risk Hazard Breakdown',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                'Project Tailored Weights',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRiskBar('Flood Exposure (NDWI)', sub.floodRisk, w['flood'] ?? 0.25, const Color(0xFF06B6D4)),
          _buildRiskBar('Urban Heat Island (LST)', sub.heatRisk, w['heat'] ?? 0.20, const Color(0xFFEF4444)),
          _buildRiskBar('Environmental Volatility', sub.envChangeRisk, w['env_change'] ?? 0.15, const Color(0xFFA855F7)),
          _buildRiskBar('Water Surface Fluctuations', sub.waterChangeRisk, w['water_change'] ?? 0.15, const Color(0xFF3B82F6)),
          _buildRiskBar('Thermal / Fire Anomalies', sub.thermalEventRisk, w['thermal'] ?? 0.10, const Color(0xFFF59E0B)),
          _buildRiskBar('Land & Geotechnical Stability', sub.siteStability, w['stability'] ?? 0.15, const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildRiskBar(String title, double score, double weight, Color color) {
    final weightPct = (weight * 100).toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222938),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Weight: $weightPct%',
                      style: const TextStyle(color: Colors.white54, fontSize: 10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${score.toStringAsFixed(1)} / 100',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (score / 100.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFF222938),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMitigationsCard(RiskAnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151921),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF222938)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.build_outlined, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text(
                'Actionable Engineering Mitigations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...result.actionableMitigations.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF10B981),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
