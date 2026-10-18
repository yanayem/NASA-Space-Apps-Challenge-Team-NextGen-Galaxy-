import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/seed_data.dart';
import '../models/risk_models.dart';
import '../widgets/indicator_chart.dart';
import '../theme/app_theme.dart';

class IndicatorsScreen extends StatefulWidget {
  const IndicatorsScreen({super.key});

  @override
  State<IndicatorsScreen> createState() => _IndicatorsScreenState();
}

class _IndicatorsScreenState extends State<IndicatorsScreen> {
  final ApiService _apiService = ApiService();

  CandidateSite _selectedSite = SeedData.sampleSites[0];
  double _startYear = 2018;
  double _endYear = 2024;
  bool _isLoading = false;
  IndicatorResponse? _indicatorResponse;

  @override
  void initState() {
    super.initState();
    _fetchIndicators();
  }

  Future<void> _fetchIndicators() async {
    setState(() => _isLoading = true);
    try {
      final res = await _apiService.fetchIndicators(
        latitude: _selectedSite.latitude,
        longitude: _selectedSite.longitude,
        startYear: _startYear.toInt(),
        endYear: _endYear.toInt(),
      );
      if (mounted) {
        setState(() {
          _indicatorResponse = res;
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
          // Filter Card
          _buildFilterCard(),
          const SizedBox(height: 20),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      'Fetching NASA Landsat & Sentinel Multi-Year Time-Series...',
                      style: TextStyle(color: context.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else if (_indicatorResponse != null) ...[
            // Trend Line Chart
            IndicatorTrendChart(
              items: _indicatorResponse!.indicators,
              selectedMetric: 'NDVI',
            ),
            const SizedBox(height: 16),

            // Satellite Observations Summary Card
            _buildSummaryCard(_indicatorResponse!),
            const SizedBox(height: 16),

            // Annual Datapoints Data Table
            _buildDatapointsTable(_indicatorResponse!),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.satellite_alt_outlined, color: AppTheme.accentEmerald, size: 20),
              const SizedBox(width: 8),
              Text(
                'NASA Earth Observation Time-Series Controls',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Target Site Dropdown
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
                    _fetchIndicators();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Year Range Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Analysis Period:', style: TextStyle(color: context.textSecondary, fontSize: 12)),
              Text(
                '${_startYear.toInt()} — ${_endYear.toInt()}',
                style: const TextStyle(
                  color: AppTheme.accentEmerald,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_startYear, _endYear),
            min: 2018,
            max: 2024,
            divisions: 6,
            activeColor: AppTheme.accentEmerald,
            inactiveColor: context.isDarkMode ? const Color(0xFF222938) : const Color(0xFFE2E8F0),
            labels: RangeLabels(
              _startYear.toInt().toString(),
              _endYear.toInt().toString(),
            ),
            onChanged: (RangeValues vals) {
              setState(() {
                _startYear = vals.start;
                _endYear = vals.end;
              });
            },
            onChangeEnd: (_) => _fetchIndicators(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(IndicatorResponse resp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentEmerald.withValues(alpha: context.isDarkMode ? 0.08 : 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentEmerald.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_graph, color: AppTheme.accentEmerald, size: 20),
              const SizedBox(width: 8),
              Text(
                'Multi-Year Remote Sensing Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            resp.summary,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatapointsTable(IndicatorResponse resp) {
    final headerRowColor = context.isDarkMode ? const Color(0xFF222938) : const Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Raw Annual Observation Log',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 18,
              headingRowHeight: 38,
              dataRowMinHeight: 44,
              headingRowColor: WidgetStateProperty.all(headerRowColor),
              columns: [
                DataColumn(label: Text('Year', style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('NDVI', style: TextStyle(color: AppTheme.accentEmerald, fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('NDWI', style: TextStyle(color: AppTheme.accentCyan, fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('NDBI', style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('LST (°C)', style: TextStyle(color: AppTheme.accentRed, fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Anomalies', style: TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold))),
              ],
              rows: resp.indicators.map((item) {
                return DataRow(cells: [
                  DataCell(Text('${item.year}', style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold))),
                  DataCell(Text('${item.ndvi}', style: TextStyle(color: context.textSecondary))),
                  DataCell(Text('${item.ndwi}', style: TextStyle(color: context.textSecondary))),
                  DataCell(Text('${item.ndbi}', style: TextStyle(color: context.textSecondary))),
                  DataCell(Text('${item.lstCelsius}°C', style: TextStyle(color: context.textSecondary))),
                  DataCell(Text('${item.thermalAnomalies}', style: TextStyle(color: context.textSecondary))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
