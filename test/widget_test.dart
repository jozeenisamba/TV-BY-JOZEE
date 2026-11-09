import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_by_jozee/main.dart';

void main() {
  testWidgets('TV BY JOZEE displays its logo', (WidgetTester tester) async {
    await tester.pumpWidget(const TVByJozeeApp());

    expect(find.text('TV BY JOZEE'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
