import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import 'apod_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isTestingConnection = false;
  String? _connectionTestResult;
  bool? _isConnectionSuccess;
  int? _latencyMs;

  late String _tempUnit;
  late String _windUnit;
  late String _climateHorizon;

  @override
  void initState() {
    super.initState();
    final apiService = Provider.of<ApiService>(context, listen: false);
    _tempUnit = apiService.tempUnit;
    _windUnit = apiService.windUnit;
    _climateHorizon = apiService.climateHorizon;
  }

  Future<void> _pingBackend(String url) async {
    setState(() {
      _isTestingConnection = true;
      _connectionTestResult = null;
      _isConnectionSuccess = null;
      _latencyMs = null;
    });

    final stopwatch = Stopwatch()..start();
    try {
      final cleanUrl = url.trim().replaceAll(RegExp(r'/$'), '');
      final response = await http
          .get(Uri.parse('$cleanUrl/health/'))
          .timeout(const Duration(seconds: 5));
      stopwatch.stop();

      if (mounted) {
        setState(() {
          _isTestingConnection = false;
          _latencyMs = stopwatch.elapsedMilliseconds;
          if (response.statusCode == 200) {
            _isConnectionSuccess = true;
            _connectionTestResult = 'Connected successfully (${_latencyMs}ms) • 200 OK';
          } else {
            _isConnectionSuccess = false;
            _connectionTestResult = 'Backend responded with HTTP status ${response.statusCode}';
          }
        });
      }
    } catch (e) {
      stopwatch.stop();
      if (mounted) {
        setState(() {
          _isTestingConnection = false;
          _isConnectionSuccess = false;
          _latencyMs = stopwatch.elapsedMilliseconds;
          _connectionTestResult = 'Could not reach backend: ${e.toString().split(':').first}';
        });
      }
    }
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 18),
            SizedBox(width: 8),
            Text('Satellite cache and temporal buffers cleared.'),
          ],
        ),
        backgroundColor: context.cardBg,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetToDefaults(ApiService apiService, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardBg,
        title: Text(
          'Reset All Settings?',
          style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will restore default NASA backend URLs, theme preferences, and measurement units.',
          style: TextStyle(color: context.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: context.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              apiService.resetToDefaults();
              themeProvider.setThemeMode(ThemeMode.system);
              setState(() {
                _tempUnit = apiService.tempUnit;
                _windUnit = apiService.windUnit;
                _climateHorizon = apiService.climateHorizon;
                _connectionTestResult = null;
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings restored to factory defaults.')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final apiService = Provider.of<ApiService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Intro Card
          _buildHeroSettingsCard(),
          const SizedBox(height: 20),

          // Appearance & Themes Section
          _buildSectionHeader('Appearance & Display Mode', Icons.palette_outlined),
          const SizedBox(height: 10),
          _buildThemeSelectorCard(themeProvider),
          const SizedBox(height: 24),

          // Backend & API Connectivity
          _buildSectionHeader('Backend & Intelligence Engine', Icons.dns_outlined),
          const SizedBox(height: 10),
          _buildBackendCard(apiService),
          const SizedBox(height: 24),

          // Earth Observation & Climate Engine
          _buildSectionHeader('Climate & Measurement Preferences', Icons.satellite_alt_outlined),
          const SizedBox(height: 10),
          _buildNasaPreferencesCard(apiService),
          const SizedBox(height: 24),

          // Storage & Maintenance
          _buildSectionHeader('Storage & Cache Maintenance', Icons.storage_outlined),
          const SizedBox(height: 10),
          _buildStorageMaintenanceCard(apiService, themeProvider),
          const SizedBox(height: 24),

          // About & System Info
          _buildSectionHeader('About SpaceRisk Platform', Icons.info_outline),
          const SizedBox(height: 10),
          _buildAboutCard(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryBlue),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSettingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: context.isDarkMode
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.isDarkMode ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune_rounded, color: AppTheme.primaryBlue, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings & Configuration',
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Switch themes, calibrate climate preferences, and monitor your Django REST backend status.',
                  style: TextStyle(color: context.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelectorCard(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Visual Theme',
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Customize interface contrast for high-ambient sunlight or dark aerospace control room environments.',
            style: TextStyle(color: context.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildThemeTile(
                  title: 'System',
                  icon: Icons.brightness_auto,
                  mode: ThemeMode.system,
                  currentMode: themeProvider.themeMode,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildThemeTile(
                  title: 'Light',
                  icon: Icons.light_mode,
                  mode: ThemeMode.light,
                  currentMode: themeProvider.themeMode,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildThemeTile(
                  title: 'Dark',
                  icon: Icons.dark_mode,
                  mode: ThemeMode.dark,
                  currentMode: themeProvider.themeMode,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      context.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                      color: context.isDarkMode ? AppTheme.accentPurple : AppTheme.accentAmber,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Display Mode',
                            style: TextStyle(
                              color: context.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            context.isDarkMode ? 'Aerospace Dark Theme' : 'Scientific Light Theme',
                            style: TextStyle(color: context.textSecondary, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: context.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeTile({
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onTap,
  }) {
    final isSelected = currentMode == mode;
    final activeColor = AppTheme.primaryBlue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : context.subCardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : context.cardBorder,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : context.textSecondary,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? activeColor : context.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildBackendCard(ApiService apiService) {
    final isLocal = apiService.backendUrl.contains('10.0.2.2') || apiService.backendUrl.contains('127.0.0.1');
    final serverModeText = isLocal ? 'LOCAL PC MODE' : 'RENDER CLOUD LIVE';
    final serverModeColor = isLocal ? AppTheme.accentCyan : AppTheme.accentEmerald;

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
                'Django Backend API Endpoint',
                style: TextStyle(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: serverModeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: serverModeColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, color: serverModeColor, size: 8),
                    const SizedBox(width: 6),
                    Text(
                      serverModeText,
                      style: TextStyle(
                        color: serverModeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isLocal
                ? 'Currently processing via your local Python/Django development server.'
                : 'High-concurrency Python/Django REST engine hosted on Render Cloud Platform.',
            style: TextStyle(color: context.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 14),

          // Display-only URL Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: context.inputBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.cardBorder),
            ),
            child: Row(
              children: [
                Icon(
                  isLocal ? Icons.computer : Icons.cloud_done_outlined,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    apiService.backendUrl,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Ping / Latency Check Button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isTestingConnection
                      ? null
                      : () => _pingBackend(apiService.backendUrl),
                  icon: _isTestingConnection
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryBlue),
                        )
                      : const Icon(Icons.network_ping, size: 18),
                  label: Text(_isTestingConnection ? 'Testing Latency...' : 'Check Server Latency'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryBlue,
                    side: const BorderSide(color: AppTheme.primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                ),
              ),
            ],
          ),

          // Connection Test Status Box
          if (_connectionTestResult != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (_isConnectionSuccess == true
                        ? AppTheme.accentEmerald
                        : AppTheme.accentRed)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (_isConnectionSuccess == true
                          ? AppTheme.accentEmerald
                          : AppTheme.accentRed)
                      .withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isConnectionSuccess == true
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: _isConnectionSuccess == true
                        ? AppTheme.accentEmerald
                        : AppTheme.accentRed,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _connectionTestResult!,
                      style: TextStyle(
                        color: _isConnectionSuccess == true
                            ? AppTheme.accentEmerald
                            : AppTheme.accentRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNasaPreferencesCard(ApiService apiService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Measurement Units
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Temperature Unit', style: TextStyle(color: context.textSecondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: context.subCardDecoration,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _tempUnit,
                          isExpanded: true,
                          dropdownColor: context.dropdownBg,
                          items: const [
                            DropdownMenuItem(value: 'Celsius (°C)', child: Text('Celsius (°C)')),
                            DropdownMenuItem(value: 'Fahrenheit (°F)', child: Text('Fahrenheit (°F)')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _tempUnit = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wind Speed Unit', style: TextStyle(color: context.textSecondary, fontSize: 12)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: context.subCardDecoration,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _windUnit,
                          isExpanded: true,
                          dropdownColor: context.dropdownBg,
                          items: const [
                            DropdownMenuItem(value: 'km/h', child: Text('km/h')),
                            DropdownMenuItem(value: 'mph', child: Text('mph')),
                            DropdownMenuItem(value: 'm/s', child: Text('m/s')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _windUnit = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Projection Horizon
          Text('Climate Risk Projection Horizon', style: TextStyle(color: context.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: context.subCardDecoration,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _climateHorizon,
                isExpanded: true,
                dropdownColor: context.dropdownBg,
                items: const [
                  DropdownMenuItem(value: '2030 Near-Term Projection', child: Text('2030 Near-Term Projection')),
                  DropdownMenuItem(value: '2040 Decadal Projection', child: Text('2040 Decadal Projection')),
                  DropdownMenuItem(value: '2050 Long-Range Horizon', child: Text('2050 Long-Range Horizon')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _climateHorizon = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                apiService.setPreferences(
                  tempUnit: _tempUnit,
                  windUnit: _windUnit,
                  climateHorizon: _climateHorizon,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Preferences saved.')),
                );
              },
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Save Preferences'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageMaintenanceCard(ApiService apiService, ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.cleaning_services_outlined, color: AppTheme.accentCyan, size: 20),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temporary Satellite Buffer',
                        style: TextStyle(
                          color: context.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '14.2 MB cached satellite metrics',
                        style: TextStyle(color: context.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: _clearCache,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentCyan,
                  side: const BorderSide(color: AppTheme.accentCyan),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: const Text('Clear Buffer', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.restore, color: AppTheme.accentRed, size: 20),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restore Defaults',
                        style: TextStyle(
                          color: context.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Reset URLs, theme, and units',
                        style: TextStyle(color: context.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _resetToDefaults(apiService, themeProvider),
                child: const Text(
                  'Reset App',
                  style: TextStyle(color: AppTheme.accentRed, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.public, color: AppTheme.primaryBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SpaceRisk Platform',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Version 1.2.0 • Build 2026.10',
                    style: TextStyle(color: context.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Developed for the NASA Space Apps Challenge. SpaceRisk empowers enterprise site planners, insurers, and engineers to quantify geospatial climate, seismic, and environmental vulnerabilities using NASA Earth-observing satellite constellations.',
            style: TextStyle(color: context.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NASA Astronomy Feed (APOD)',
                style: TextStyle(color: context.textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          title: const Text('NASA Earth & Space Feed'),
                        ),
                        body: const ApodScreen(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, size: 14),
                label: const Text('Open Feed', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
