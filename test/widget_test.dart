import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('BottomNavigationBar und grundlegende Navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.text('Feed'), findsOneWidget);
    expect(find.text('Karte'), findsOneWidget);
    expect(find.text('Infos'), findsOneWidget);
    expect(find.text('Über uns'), findsOneWidget);

    expect(find.text('Newsfeed'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.info));
    await tester.pump();

    expect(find.text('Newsfeed'), findsNothing);
    expect(find.text('Aktuelle Infos'), findsOneWidget);
  });
}
