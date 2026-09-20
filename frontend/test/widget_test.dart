import 'package:fitflow_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows dashboard and navigates to nutrition', (tester) async {
    await tester.pumpWidget(const FitFlowApp());

    expect(find.text('FitFlow'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Next workout'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.restaurant_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Nutrition'), findsWidgets);
    expect(find.text('Add meal'), findsWidgets);
  });
}
