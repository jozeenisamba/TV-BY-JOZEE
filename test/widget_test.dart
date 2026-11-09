import 'package:flutter_test/flutter_test.dart';
import 'package:tv_by_jozee/main.dart';

void main() {
  testWidgets('TV BY JOZEE app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const TVByJozeeApp());

    expect(find.text('TV BY '), findsOneWidget);
    expect(find.text('JOZEE'), findsOneWidget);
  });
}
