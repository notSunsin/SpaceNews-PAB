import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const SpaceNewsCoreApp());
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
  });
}
