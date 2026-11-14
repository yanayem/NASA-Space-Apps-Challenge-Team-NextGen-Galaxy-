import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/risk_models.dart';
import '../models/preset_sites.dart';
import '../theme/app_theme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService _apiService = ApiService();

  CandidateSite _selectedSite = PresetSites.sampleSites[0];
  String _projectType = 'warehouse';
  bool _isGenerating = false;
  String? _errorMessage;
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
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

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
        setState(() {
          _errorMessage = 'Failed to generate risk report ($e)';
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 750;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Generator Controls Card
          _buildControlsCard(isWide),
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
          else if (_errorMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: context.cardDecoration,
                child: Column(
                  children: [
                    const Icon(Icons.cloud_off, size: 44, color: AppTheme.accentAmber),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: context.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _generateReport,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry Report Generation'),
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

  Widget _buildControlsCard(bool isWide) {
    final siteSelector = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              items: PresetSites.sampleSites.map((site) {
                return DropdownMenuItem<CandidateSite>(
                  value: site,
                  child: Text(
                    site.name,
                    style: TextStyle(color: context.textPrimary, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
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
      ],
    );

    final typeSelector = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    overflow: TextOverflow.ellipsis,
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
      ],
    );

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

          if (isWide)
            Row(
              children: [
                Expanded(child: siteSelector),
                const SizedBox(width: 16),
                Expanded(child: typeSelector),
              ],
            )
          else ...[
            siteSelector,
            const SizedBox(height: 12),
            typeSelector,
          ],
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentAmber,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _generateReport,
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('Generate PDF Executive Summary Report'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportPreviewCard(ExecutiveReport report) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(
                  report.reportId,
                  style: const TextStyle(
                    color: AppTheme.accentAmber,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                backgroundColor: AppTheme.accentAmber.withValues(alpha: 0.15),
                side: const BorderSide(color: AppTheme.accentAmber),
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
          const SizedBox(height: 8),
          Text(
            report.summary,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryBlue,
                side: const BorderSide(color: AppTheme.primaryBlue),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Report Download Link: ${report.downloadUrl}'),
                  ),
                );
              },
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Download Executive PDF Report'),
            ),
          ),
        ],
      ),
    );
  }
}
