import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/risk_models.dart';
import '../models/preset_sites.dart';
import '../theme/app_theme.dart';

class SiteComparisonScreen extends StatefulWidget {
  const SiteComparisonScreen({super.key});

  @override
  State<SiteComparisonScreen> createState() => _SiteComparisonScreenState();
}

class _SiteComparisonScreenState extends State<SiteComparisonScreen> {
  final ApiService _apiService = ApiService();

  final List<CandidateSite> _selectedSites = [
    PresetSites.sampleSites[0],
    PresetSites.sampleSites[1],
    PresetSites.sampleSites[3],
  ];

  String _projectType = 'warehouse';
  bool _isLoading = false;
  String? _errorMessage;
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

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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
        setState(() {
          _errorMessage = 'Failed to run site comparison ($e)';
          _isLoading = false;
        });
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
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text(
                      'Running Multi-Site Satellite Comparison Engine...',
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
                      onPressed: _runComparison,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry Comparison'),
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
            Text(
              'Detailed Candidate Evaluation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows_rounded, color: AppTheme.accentPurple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Multi-Site Comparison Controls',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Project Type Dropdown
          Row(
            children: [
              Text('Project:', style: TextStyle(color: context.textSecondary, fontSize: 12)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
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

          Text('Select Candidate Sites (2 to 5):', style: TextStyle(color: context.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: PresetSites.sampleSites.map((site) {
              final isSelected = _selectedSites.contains(site);
              return FilterChip(
                selected: isSelected,
                label: Text(site.name),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : context.textSecondary,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                selectedColor: AppTheme.accentPurple.withValues(alpha: 0.85),
                backgroundColor: context.subCardBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppTheme.accentPurple : context.cardBorder,
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
          colors: context.isDarkMode
              ? [
                  AppTheme.accentEmerald.withValues(alpha: 0.2),
                  const Color(0xFF0B0E14),
                ]
              : [
                  const Color(0xFFDCFCE7),
                  const Color(0xFFF0FDF4),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentEmerald.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accentEmerald.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star_rounded, color: AppTheme.accentEmerald, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RECOMMENDED OPTIMAL SITE',
                      style: TextStyle(
                        color: AppTheme.accentEmerald,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      resp.recommendedSite,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
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
            style: TextStyle(color: context.textSecondary, fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixTable(SiteComparisonResponse resp) {
    final headerRowColor = context.isDarkMode ? const Color(0xFF222938) : const Color(0xFFE2E8F0);
    final borderColor = context.cardBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Side-by-Side Matrix Comparison',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                    fontSize: 15,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.swipe_left_rounded, size: 14, color: context.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'Swipe table →',
                    style: TextStyle(color: context.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Container(
                      color: headerRowColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              'Metric',
                              style: TextStyle(
                                color: context.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          ...resp.comparisonResults.map((e) {
                            final isRec = e.siteName == resp.recommendedSite;
                            return Container(
                              width: 140,
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isRec)
                                    const Padding(
                                      padding: EdgeInsets.only(right: 4),
                                      child: Icon(Icons.star_rounded, color: AppTheme.accentEmerald, size: 16),
                                    ),
                                  Expanded(
                                    child: Text(
                                      e.siteName,
                                      style: TextStyle(
                                        color: isRec ? AppTheme.accentEmerald : context.textPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // Data Rows
                    _buildMatrixRow('SpaceRisk Score', resp.comparisonResults, (item) {
                      return Text(
                        '${item.spaceRiskScore}',
                        style: TextStyle(
                          color: item.spaceRiskScore < 50 ? AppTheme.accentEmerald : AppTheme.accentRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      );
                    }, isFirst: true),

                    _buildMatrixRow('Risk Category', resp.comparisonResults, (item) {
                      return Text(
                        item.riskLevel,
                        style: TextStyle(color: context.textPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),

                    _buildMatrixRow('Flood Risk', resp.comparisonResults, (item) {
                      return Text('${item.floodRisk}', style: TextStyle(color: context.textSecondary, fontSize: 12));
                    }),

                    _buildMatrixRow('Heat Risk', resp.comparisonResults, (item) {
                      return Text('${item.heatRisk}', style: TextStyle(color: context.textSecondary, fontSize: 12));
                    }),

                    _buildMatrixRow('Water Volatility', resp.comparisonResults, (item) {
                      return Text('${item.waterChange}', style: TextStyle(color: context.textSecondary, fontSize: 12));
                    }, isLast: true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixRow(
    String metricName,
    List<SiteComparisonItem> items,
    Widget Function(SiteComparisonItem) cellBuilder, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: context.cardBorder.withValues(alpha: 0.5))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              metricName,
              style: TextStyle(color: context.textSecondary, fontSize: 12, fontWeight: isFirst ? FontWeight.w600 : FontWeight.normal),
            ),
          ),
          ...items.map((item) {
            return SizedBox(
              width: 140,
              child: cellBuilder(item),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(SiteComparisonItem item, bool isRecommended) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecommended ? AppTheme.accentEmerald : context.cardBorder,
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
                        child: Icon(Icons.star, color: AppTheme.accentEmerald, size: 18),
                      ),
                    Expanded(
                      child: Text(
                        item.siteName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isRecommended
                      ? AppTheme.accentEmerald.withValues(alpha: 0.18)
                      : context.subCardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isRecommended ? AppTheme.accentEmerald : context.cardBorder,
                  ),
                ),
                child: Text(
                  'Score: ${item.spaceRiskScore}',
                  style: TextStyle(
                    color: isRecommended ? AppTheme.accentEmerald : context.textPrimary,
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
            style: TextStyle(color: context.textSecondary, fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
  }
}
