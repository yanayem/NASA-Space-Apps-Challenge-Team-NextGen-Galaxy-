import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile/main.dart';
import 'package:mobile/services/api_service.dart';
import 'package:mobile/theme/theme_provider.dart';

void main() {
  testWidgets('SpaceRiskApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ApiService>(create: (_) => ApiService()),
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ],
        child: const SpaceRiskApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('SpaceRisk Dashboard'), findsOneWidget);
  });
}
