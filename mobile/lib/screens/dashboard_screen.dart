import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/seed_data.dart';
import '../models/risk_models.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const DashboardScreen({super.key, required this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  CandidateSite _selectedPreset = SeedData.sampleSites[0];
  bool _isBackendConnected = false;

  @override
  void initState() {
    super.initState();
    _checkBackendStatus();
  }

  Future<void> _checkBackendStatus() async {
    final isConnected = await _apiService.checkHealth();
    if (mounted) {
      setState(() {
        _isBackendConnected = isConnected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner for Seed/Demo Data Mode
          _buildModeStatusCard(),
          const SizedBox(height: 16),

          // Header Hero Section
          _buildHeroHeader(),
          const SizedBox(height: 20),

          // Quick Navigation Features Grid
          const Text(
            'Core Intelligence Modules',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildFeatureGrid(),
          const SizedBox(height: 24),

          // Preset Candidate Locations Selector
          const Text(
            'Explore Target Candidate Sites',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildPresetSiteList(),
          const SizedBox(height: 24),

          // System Status & Architecture Card
          _buildSystemStatusCard(),
        ],
      ),
    );
  }

  Widget _buildModeStatusCard() {
    final useSeed = _apiService.useSeedDataMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: useSeed
            ? const Color(0xFF3B82F6).withValues(alpha: 0.12)
            : (_isBackendConnected
                ? const Color(0xFF10B981).withValues(alpha: 0.12)
                : const Color(0xFFF59E0B).withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: useSeed
              ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
              : (_isBackendConnected
                  ? const Color(0xFF10B981).withValues(alpha: 0.4)
                  : const Color(0xFFF59E0B).withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            useSeed
                ? Icons.dataset_linked
                : (_isBackendConnected ? Icons.cloud_done : Icons.wifi_off),
            color: useSeed
                ? const Color(0xFF3B82F6)
                : (_isBackendConnected
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B)),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  useSeed
                      ? 'Seed & Demo Data Mode Active'
                      : (_isBackendConnected
                          ? 'Connected to SpaceRisk REST API'
                          : 'Backend Offline — Auto Seed Mode Active'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                Text(
                  useSeed
                      ? 'Using rich offline seed datasets for demonstration.'
                      : (_isBackendConnected
                          ? 'Live NASA Earth-Observation data pipeline ready.'
                          : 'Serving local seed & demo data seamlessly.'),
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: useSeed,
            activeThumbColor: const Color(0xFF3B82F6),
            onChanged: (val) {
              setState(() {
                _apiService.setSeedDataMode(val);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.public,
                  color: Color(0xFF3B82F6),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SpaceRisk Platform',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Infrastructure Risk Intelligence Engine',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Multi-spectral NASA Earth-observation analytics (Landsat 8/9, Sentinel, MODIS, VIIRS) evaluating flood, heat, vegetation, and land stability hazards.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        _buildFeatureCard(
          title: 'Site Risk Analysis',
          subtitle: 'Evaluate 0-100 Score',
          icon: Icons.analytics_outlined,
          color: const Color(0xFF3B82F6),
          onTap: () => widget.onNavigateTab(1),
        ),
        _buildFeatureCard(
          title: 'Site Comparison',
          subtitle: 'Compare 2-5 Locations',
          icon: Icons.compare_arrows_rounded,
          color: const Color(0xFF8B5CF6),
          onTap: () => widget.onNavigateTab(2),
        ),
        _buildFeatureCard(
          title: 'Satellite Trends',
          subtitle: 'NDVI, NDWI, LST °C',
          icon: Icons.show_chart_rounded,
          color: const Color(0xFF10B981),
          onTap: () => widget.onNavigateTab(3),
        ),
        _buildFeatureCard(
          title: 'B2B PDF Reports',
          subtitle: 'Executive Summary',
          icon: Icons.picture_as_pdf_outlined,
          color: const Color(0xFFF59E0B),
          onTap: () => widget.onNavigateTab(4),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF151921),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF222938)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetSiteList() {
    return Column(
      children: SeedData.sampleSites.map((site) {
        final isSelected = _selectedPreset.id == site.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedPreset = site;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                    : const Color(0xFF151921),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF222938),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : Colors.white38,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${site.region} (${site.latitude}, ${site.longitude})',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF222938),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      widget.onNavigateTab(1);
                    },
                    child: const Text('Analyze', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSystemStatusCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.hub_outlined, color: Color(0xFF8B5CF6), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Backend & Data Pipeline',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18, color: Colors.white54),
                onPressed: _checkBackendStatus,
                tooltip: 'Check Status',
              ),
            ],
          ),
          const Divider(color: Color(0xFF222938), height: 20),
          _buildStatusRow(
            'Django REST API',
            _isBackendConnected ? 'Online (HTTP 200)' : 'Offline / Seed Fallback',
            _isBackendConnected ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'NASA Earthdata Feed',
            'Landsat 8/9, Sentinel & VIIRS Active',
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 8),
          _buildStatusRow(
            'Seed Dataset Pipeline',
            'Pre-seeded Multi-Year Data Active',
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String service, String status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          service,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
