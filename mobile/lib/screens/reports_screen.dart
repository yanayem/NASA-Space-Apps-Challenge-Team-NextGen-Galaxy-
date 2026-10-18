import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/seed_data.dart';
import '../models/risk_models.dart';
import '../theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService _apiService = ApiService();

  CandidateSite _selectedSite = SeedData.sampleSites[0];
  String _projectType = 'warehouse';
  bool _isGenerating = false;
  ExecutiveReport? _generatedReport;

  final Map<String, String> _projectTypes = {
    'warehouse': 'Warehouse / Logistics Hub',
    'factory': 'Industrial Factory',
    'solar_farm': 'Solar Power Farm',
    'telecom_tower': 'Telecom Infrastructure Tower',
    'data_center': 'Data Center Facility',
  };

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);
    try {
      final res = await _apiService.generateReport(
        siteName: _selectedSite.name,
        projectType: _projectType,
        latitude: _selectedSite.latitude,
        longitude: _selectedSite.longitude,
      );
      if (mounted) {
        setState(() {
          _generatedReport = res;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
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
          // Generator Controls Card
          _buildControlsCard(),
          const SizedBox(height: 20),

          if (_isGenerating)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      'Compiling B2B Executive Investment Risk PDF Report...',
                      style: TextStyle(color: context.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else if (_generatedReport != null) ...[
            _buildReportPreviewCard(_generatedReport!),
          ],
        ],
      ),
    );
  }

  Widget _buildControlsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.accentAmber, size: 20),
              const SizedBox(width: 8),
              Text(
                'B2B Executive Risk Report Generator',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Select Target Site
          Text('Select Target Site:', style: TextStyle(color: context.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: context.subCardDecoration,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CandidateSite>(
                value: _selectedSite,
                isExpanded: true,
                dropdownColor: context.dropdownBg,
                items: SeedData.sampleSites.map((site) {
                  return DropdownMenuItem<CandidateSite>(
                    value: site,
                    child: Text(
                      site.name,
                      style: TextStyle(color: context.textPrimary, fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedSite = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Infrastructure Project Type
          Text('Infrastructure Project Type:', style: TextStyle(color: context.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: context.subCardDecoration,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _projectType,
                isExpanded: true,
                dropdownColor: context.dropdownBg,
                items: _projectTypes.entries.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.key,
                    child: Text(
                      e.value,
                      style: TextStyle(color: context.textPrimary, fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _projectType = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentAmber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _generateReport,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text(
                'Generate Executive PDF Report',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportPreviewCard(ExecutiveReport report) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentAmber.withValues(alpha: 0.4)),
        boxShadow: context.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report.reportId,
                  style: const TextStyle(
                    color: AppTheme.accentAmber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                report.generatedAt,
                style: TextStyle(color: context.textSecondary, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            report.siteName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Infrastructure Category: ${_projectTypes[_projectType] ?? _projectType}',
            style: TextStyle(color: context.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Divider(color: context.cardBorder),
          const SizedBox(height: 12),

          Text(
            'Executive Assessment Summary:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            report.summary,
            style: TextStyle(color: context.textSecondary, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.accentAmber),
                foregroundColor: AppTheme.accentAmber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloading Executive PDF Report (${report.reportId})...'),
                  ),
                );
              },
              icon: const Icon(Icons.download_rounded),
              label: const Text(
                'Download Full PDF Assessment Report',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
