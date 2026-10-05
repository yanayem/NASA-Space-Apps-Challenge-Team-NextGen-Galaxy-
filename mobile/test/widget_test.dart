import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile/main.dart';
import 'package:mobile/services/api_service.dart';

void main() {
  testWidgets('SpaceRiskApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ApiService>(
        create: (_) => ApiService(),
        child: const SpaceRiskApp(),
      ),
    );
    expect(find.text('SpaceRisk Dashboard'), findsOneWidget);
  });
}
