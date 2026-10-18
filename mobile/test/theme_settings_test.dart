import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/theme/app_theme.dart';
import 'package:mobile/theme/theme_provider.dart';
import 'package:mobile/screens/settings_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('ThemeProvider toggles and persists theme mode', () async {
    final themeProvider = ThemeProvider();
    expect(themeProvider.themeMode, ThemeMode.system);

    await themeProvider.setThemeMode(ThemeMode.light);
    expect(themeProvider.themeMode, ThemeMode.light);

    await themeProvider.setThemeMode(ThemeMode.dark);
    expect(themeProvider.themeMode, ThemeMode.dark);

    await themeProvider.setThemeMode(ThemeMode.system);
    expect(themeProvider.themeMode, ThemeMode.system);
  });

  testWidgets('SettingsScreen renders themes and backend configuration correctly',
      (WidgetTester tester) async {
    final apiService = ApiService();
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiService>.value(value: apiService),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify sections and tiles
    expect(find.text('Settings & Configuration'), findsOneWidget);
    expect(find.text('Choose Visual Theme'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('Django Backend API Endpoint'), findsOneWidget);

    // Tap Light Theme tile
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(themeProvider.themeMode, ThemeMode.light);

    // Tap Dark Theme tile
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(themeProvider.themeMode, ThemeMode.dark);
  });
}
