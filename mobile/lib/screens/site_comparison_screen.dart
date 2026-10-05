import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/seed_data.dart';
import '../models/risk_models.dart';

class SiteComparisonScreen extends StatefulWidget {
  const SiteComparisonScreen({super.key});

  @override
  State<SiteComparisonScreen> createState() => _SiteComparisonScreenState();
}

class _SiteComparisonScreenState extends State<SiteComparisonScreen> {
  final ApiService _apiService = ApiService();

  final List<CandidateSite> _selectedSites = [
    SeedData.sampleSites[0],
    SeedData.sampleSites[1],
    SeedData.sampleSites[3],
  ];

  String _projectType = 'warehouse';
  bool _isLoading = false;
  SiteComparisonResponse? _comparisonResponse;

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
    _runComparison();
  }

  Future<void> _runComparison() async {
    if (_selectedSites.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 2 candidate sites to compare.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final res = await _apiService.compareSites(
        projectType: _projectType,
        sites: _selectedSites,
      );
      if (mounted) {
        setState(() {
          _comparisonResponse = res;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleSite(CandidateSite site) {
    setState(() {
      if (_selectedSites.contains(site)) {
        if (_selectedSites.length > 2) {
          _selectedSites.remove(site);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('At least 2 sites required for comparison.')),
          );
        }
      } else {
        if (_selectedSites.length < 5) {
          _selectedSites.add(site);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 5 sites allowed for comparison matrix.')),
          );
        }
      }
    });
    _runComparison();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector Card
          _buildSelectorCard(),
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
                      'Running Multi-Site Satellite Comparison Engine...',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )
          else if (_comparisonResponse != null) ...[
            // Optimal Recommended Site Banner
            _buildRecommendationBanner(_comparisonResponse!),
            const SizedBox(height: 16),

            // Side-by-Side Matrix Table
            _buildMatrixTable(_comparisonResponse!),
            const SizedBox(height: 20),

            // Candidate Site Cards
            const Text(
              'Detailed Candidate Evaluation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ..._comparisonResponse!.comparisonResults.map((item) {
              final isRecommended = item.siteName == _comparisonResponse!.recommendedSite;
              return _buildCandidateCard(item, isRecommended);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectorCard() {
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
              Icon(Icons.compare_arrows_rounded, color: Color(0xFF8B5CF6), size: 20),
              SizedBox(width: 8),
              Text(
                'Multi-Site Comparison Controls',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Project Type Dropdown
          Row(
            children: [
              const Text('Project:', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
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
                          _runComparison();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          const Text('Select Candidate Sites (2 to 5):', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: SeedData.sampleSites.map((site) {
              final isSelected = _selectedSites.contains(site);
              return FilterChip(
                selected: isSelected,
                label: Text(site.name),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                selectedColor: const Color(0xFF8B5CF6).withValues(alpha: 0.8),
                backgroundColor: const Color(0xFF0B0E14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF222938),
                  ),
                ),
                onSelected: (_) => _toggleSite(site),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationBanner(SiteComparisonResponse resp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.2),
            const Color(0xFF0B0E14),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: Color(0xFF10B981), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RECOMMENDED OPTIMAL SITE',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      resp.recommendedSite,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            resp.comparisonSummary,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.87), fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixTable(SiteComparisonResponse resp) {
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
            'Side-by-Side Matrix Comparison',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowHeight: 40,
              dataRowMinHeight: 48,
              headingRowColor: WidgetStateProperty.all(const Color(0xFF222938)),
              columns: [
                const DataColumn(label: Text('Metric', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ...resp.comparisonResults.map((e) {
                  final isRec = e.siteName == resp.recommendedSite;
                  return DataColumn(
                    label: Text(
                      isRec ? '${e.siteName} ⭐' : e.siteName,
                      style: TextStyle(
                        color: isRec ? const Color(0xFF10B981) : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('SpaceRisk Score', style: TextStyle(color: Colors.white70))),
                  ...resp.comparisonResults.map((e) => DataCell(
                        Text(
                          '${e.spaceRiskScore}',
                          style: TextStyle(
                            color: e.spaceRiskScore < 50 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Risk Category', style: TextStyle(color: Colors.white70))),
                  ...resp.comparisonResults.map((e) => DataCell(Text(e.riskLevel, style: const TextStyle(color: Colors.white)))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Flood Risk', style: TextStyle(color: Colors.white70))),
                  ...resp.comparisonResults.map((e) => DataCell(Text('${e.floodRisk}', style: const TextStyle(color: Colors.white70)))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Heat Risk', style: TextStyle(color: Colors.white70))),
                  ...resp.comparisonResults.map((e) => DataCell(Text('${e.heatRisk}', style: const TextStyle(color: Colors.white70)))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Water Volatility', style: TextStyle(color: Colors.white70))),
                  ...resp.comparisonResults.map((e) => DataCell(Text('${e.waterChange}', style: const TextStyle(color: Colors.white70)))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(SiteComparisonItem item, bool isRecommended) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF151921),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecommended ? const Color(0xFF10B981) : const Color(0xFF222938),
          width: isRecommended ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (isRecommended)
                      const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: Icon(Icons.star, color: Color(0xFF10B981), size: 18),
                      ),
                    Expanded(
                      child: Text(
                        item.siteName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isRecommended
                      ? const Color(0xFF10B981).withValues(alpha: 0.2)
                      : const Color(0xFF222938),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Score: ${item.spaceRiskScore}',
                  style: TextStyle(
                    color: isRecommended ? const Color(0xFF10B981) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.keyRecommendation,
            style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
  }
}
