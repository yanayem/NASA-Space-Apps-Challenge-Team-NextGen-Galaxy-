import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/site_risk_screen.dart';
import 'screens/site_comparison_screen.dart';
import 'screens/indicators_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/apod_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const SpaceRiskApp(),
    ),
  );
}

class SpaceRiskApp extends StatelessWidget {
  const SpaceRiskApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SpaceRisk — Infrastructure Risk Intelligence',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWideScreen = width >= 800;

    final List<Widget> screens = [
      DashboardScreen(onNavigateTab: _navigateToTab),
      const SiteRiskScreen(),
      const SiteComparisonScreen(),
      const IndicatorsScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
      const ApodScreen(),
    ];

    final List<String> titles = [
      'SpaceRisk Dashboard',
      'Site Risk Evaluation',
      'Multi-Site Comparison Matrix',
      'Satellite Environmental Trends',
      'Executive Risk Reports',
      'Settings & System Engine',
      'NASA Earth & Space Feed',
    ];

    final mainBody = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: IndexedStack(
          index: _currentIndex < screens.length ? _currentIndex : 0,
          children: screens,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.public, color: AppTheme.primaryBlue, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titles[_currentIndex < titles.length ? _currentIndex : 0],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Settings Action Button
          IconButton(
            icon: Icon(
              _currentIndex == 5 ? Icons.tune : Icons.tune_outlined,
              size: 20,
              color: _currentIndex == 5 ? AppTheme.primaryBlue : null,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 5;
              });
            },
            tooltip: 'App & Backend Settings',
          ),
        ],
      ),
      body: isWideScreen
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex < 7 ? _currentIndex : 0,
                  indicatorColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  labelType: width > 1100
                      ? NavigationRailLabelType.all
                      : NavigationRailLabelType.selected,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CircleAvatar(
                      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.15),
                      child: const Icon(Icons.satellite_alt, color: AppTheme.primaryBlue, size: 20),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryBlue),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.analytics_outlined),
                      selectedIcon: Icon(Icons.analytics, color: AppTheme.primaryBlue),
                      label: Text('Risk Score'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.compare_arrows_rounded),
                      selectedIcon: Icon(Icons.compare_arrows, color: AppTheme.primaryBlue),
                      label: Text('Compare'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.show_chart_rounded),
                      selectedIcon: Icon(Icons.show_chart, color: AppTheme.primaryBlue),
                      label: Text('Trends'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.picture_as_pdf_outlined),
                      selectedIcon: Icon(Icons.picture_as_pdf, color: AppTheme.primaryBlue),
                      label: Text('Reports'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.tune_outlined),
                      selectedIcon: Icon(Icons.tune, color: AppTheme.primaryBlue),
                      label: Text('Settings'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_awesome_outlined),
                      selectedIcon: Icon(Icons.auto_awesome, color: AppTheme.primaryBlue),
                      label: Text('NASA Feed'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: mainBody),
              ],
            )
          : mainBody,
      bottomNavigationBar: isWideScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex > 5 ? 0 : _currentIndex,
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.tune_outlined),
                  activeIcon: Icon(Icons.tune),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }
}
