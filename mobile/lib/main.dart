import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/site_risk_screen.dart';
import 'screens/site_comparison_screen.dart';
import 'screens/indicators_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/apod_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<ApiService>(
      create: (_) => ApiService(),
      child: const SpaceRiskApp(),
    ),
  );
}

class SpaceRiskApp extends StatelessWidget {
  const SpaceRiskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceRisk — Infrastructure Risk Intelligence',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0E14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF3B82F6),
          secondary: Color(0xFF8B5CF6),
          surface: Color(0xFF151921),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151921),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF151921),
          selectedItemColor: Color(0xFF3B82F6),
          unselectedItemColor: Colors.white54,
        ),
      ),
      home: const MainNavigationContainer(),
    );
  }
}

class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showBackendSettingsDialog(BuildContext context, ApiService apiService) {
    final controller = TextEditingController(text: apiService.backendUrl);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151921),
          title: const Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF3B82F6)),
              SizedBox(width: 8),
              Expanded(child: Text('API & Seed Data Settings')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Django Backend API Endpoint URL:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF0B0E14),
                  hintText: 'http://192.168.0.163:8000/api',
                  hintStyle: const TextStyle(color: Colors.white38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF222938)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setLocalState) {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Force Seed & Demo Data Mode'),
                    subtitle: const Text(
                      'Use local rich seed datasets without contacting backend.',
                      style: TextStyle(fontSize: 11, color: Colors.white54),
                    ),
                    value: apiService.useSeedDataMode,
                    activeThumbColor: const Color(0xFF3B82F6),
                    onChanged: (val) {
                      apiService.setSeedDataMode(val);
                      setLocalState(() {});
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                apiService.setBackendUrl(controller.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backend settings updated successfully.')),
                );
              },
              child: const Text('Save Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    final List<Widget> screens = [
      DashboardScreen(onNavigateTab: _navigateToTab),
      const SiteRiskScreen(),
      const SiteComparisonScreen(),
      const IndicatorsScreen(),
      const ReportsScreen(),
      const ApodScreen(),
    ];

    final List<String> titles = [
      'SpaceRisk Dashboard',
      'Site Risk Evaluation',
      'Multi-Site Comparison Matrix',
      'Satellite Environmental Trends',
      'Executive Risk Reports',
      'NASA Earth & Space Feed',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.public, color: Color(0xFF3B82F6), size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titles[_currentIndex],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (apiService.useSeedDataMode || apiService.lastRequestWasDemo)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF3B82F6), width: 1),
              ),
              child: const Row(
                children: [
                  Icon(Icons.sd_card, color: Color(0xFF3B82F6), size: 12),
                  SizedBox(width: 4),
                  Text(
                    'SEED DATA',
                    style: TextStyle(
                      color: Color(0xFF3B82F6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 20),
            onPressed: () => _showBackendSettingsDialog(context, apiService),
            tooltip: 'API & Seed Settings',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Risk 0-100',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows_rounded),
            activeIcon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_rounded),
            activeIcon: Icon(Icons.show_chart),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf_outlined),
            activeIcon: Icon(Icons.picture_as_pdf),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}
