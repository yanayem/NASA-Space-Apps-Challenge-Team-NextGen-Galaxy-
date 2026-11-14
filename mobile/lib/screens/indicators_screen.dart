import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/risk_models.dart';
import '../models/preset_sites.dart';
import '../widgets/indicator_chart.dart';
import '../theme/app_theme.dart';

class IndicatorsScreen extends StatefulWidget {
  const IndicatorsScreen({super.key});

  @override
  State<IndicatorsScreen> createState() => _IndicatorsScreenState();
}

class _IndicatorsScreenState extends State<IndicatorsScreen> {
  final ApiService _apiService = ApiService();

  CandidateSite _selectedSite = PresetSites.sampleSites[0];
  double _startYear = 2018;
  double _endYear = 2024;
  bool _isLoading = false;
  String? _errorMessage;
  IndicatorResponse? _indicatorResponse;

  @override
  void initState() {
    super.initState();
    _fetchIndicators();
  }

  Future<void> _fetchIndicators() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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
        setState(() {
          _errorMessage = 'Failed to fetch satellite indicators ($e)';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 850;

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
                      onPressed: _fetchIndicators,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry Fetching Datasets'),
                    ),
                  ],
                ),
              ),
            )
          else if (_indicatorResponse != null) ...[
            if (isWide) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: IndicatorTrendChart(
                      items: _indicatorResponse!.indicators,
                      selectedMetric: 'NDVI',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        _buildSummaryCard(_indicatorResponse!),
                        const SizedBox(height: 16),
                        _buildDatapointsTable(_indicatorResponse!),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Trend Line Chart
              IndicatorTrendChart(
                items: _indicatorResponse!.indicators,
                selectedMetric: 'NDVI',
              ),
              const SizedBox(height: 16),

              // Satellite Observations Summary Card
              _buildSummaryCard(_indicatorResponse!),
              const SizedBox(height: 16),

              // NASA HLS Live Granules & Catalogs Card
              _buildNasaGranulesCard(_indicatorResponse!),
              const SizedBox(height: 16),

              // Annual Datapoints Data Table
              _buildDatapointsTable(_indicatorResponse!),
            ],
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
                items: PresetSites.sampleSites.map((site) {
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

  Widget _buildNasaGranulesCard(IndicatorResponse resp) {
    if (resp.nasaGranules.isEmpty && resp.nasaCatalogs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.satellite_alt_rounded, color: AppTheme.accentCyan, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'NASA HLS Live Granules & Catalogs',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (resp.hlsTileId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentCyan.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    'Tile: ${resp.hlsTileId}',
                    style: const TextStyle(
                      color: AppTheme.accentCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Live satellite data tiles queried from NASA Common Metadata Repository (CMR):',
            style: TextStyle(color: context.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 10),
          ...resp.nasaGranules.map((granule) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: context.subCardDecoration,
              child: Row(
                children: [
                  const Icon(Icons.dataset_outlined, size: 18, color: AppTheme.primaryBlue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          granule.collectionName.isNotEmpty ? granule.collectionName : granule.collection,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (granule.granuleId.isNotEmpty)
                          Text(
                            'Granule: ${granule.granuleId}',
                            style: TextStyle(color: context.textMuted, fontSize: 10.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (granule.provider.isNotEmpty)
                    Chip(
                      label: Text(
                        granule.provider,
                        style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.8),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            );
          }),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Raw Annual Observation Log',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.swipe_left_rounded, size: 14, color: context.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'Swipe →',
                    style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: DataTable(
                columnSpacing: 18,
                headingRowHeight: 40,
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
          ),
        ],
      ),
    );
  }
}
