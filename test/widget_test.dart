import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_app/calculator_page.dart';

void main() {
  testWidgets('calculator renders initial display and buttons', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: calculator_page()));

    expect(find.text('0'), findsWidgets);
    expect(find.text('AC'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
  });
}
