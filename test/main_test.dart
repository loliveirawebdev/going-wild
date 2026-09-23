import 'package:flutter_test/flutter_test.dart';
import 'package:going_wild/main.dart';

void main() {
  testWidgets('renders hello world', (tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
