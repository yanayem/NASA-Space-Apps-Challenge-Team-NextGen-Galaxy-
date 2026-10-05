import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/seed_data.dart';
import '../models/risk_models.dart';
import '../widgets/indicator_chart.dart';

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
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Fetching NASA Landsat & Sentinel Multi-Year Time-Series...',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
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
              Icon(Icons.satellite_alt_outlined, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text(
                'NASA Earth Observation Time-Series Controls',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Target Site Dropdown
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
              const Text('Analysis Period:', style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                '${_startYear.toInt()} — ${_endYear.toInt()}',
                style: const TextStyle(
                  color: Color(0xFF10B981),
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
            activeColor: const Color(0xFF10B981),
            inactiveColor: const Color(0xFF222938),
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
        color: const Color(0xFF10B981).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_graph, color: Color(0xFF10B981), size: 20),
              SizedBox(width: 8),
              Text(
                'Multi-Year Remote Sensing Summary',
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
            resp.summary,
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

  Widget _buildDatapointsTable(IndicatorResponse resp) {
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
          const Text(
            'Raw Annual Observation Log',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
              headingRowColor: WidgetStateProperty.all(const Color(0xFF222938)),
              columns: const [
                DataColumn(label: Text('Year', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('NDVI', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold))),
                DataColumn(label: Text('NDWI', style: TextStyle(color: Color(0xFF06B6D4), fontWeight: FontWeight.bold))),
                DataColumn(label: Text('NDBI', style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold))),
                DataColumn(label: Text('LST (°C)', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Anomalies', style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold))),
              ],
              rows: resp.indicators.map((item) {
                return DataRow(cells: [
                  DataCell(Text('${item.year}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  DataCell(Text('${item.ndvi}', style: const TextStyle(color: Colors.white70))),
                  DataCell(Text('${item.ndwi}', style: const TextStyle(color: Colors.white70))),
                  DataCell(Text('${item.ndbi}', style: const TextStyle(color: Colors.white70))),
                  DataCell(Text('${item.lstCelsius}°C', style: const TextStyle(color: Colors.white70))),
                  DataCell(Text('${item.thermalAnomalies}', style: const TextStyle(color: Colors.white70))),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
