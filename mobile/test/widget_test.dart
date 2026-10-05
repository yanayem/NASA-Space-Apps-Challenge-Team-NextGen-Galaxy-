import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('NasaSpaceApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NasaSpaceApp());
    expect(find.text('NASA Space Explorer'), findsOneWidget);
  });
}
