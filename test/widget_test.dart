import 'package:app/model/post.dart';
import 'package:app/page/about/about.dart';
import 'package:app/page/feed/feed.dart';
import 'package:app/page/feed/post.dart';
import 'package:app/service/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/app.dart';
import 'package:app/main.dart';

void main() {
  api = ApiService();

  /* testWidgets('BottomNavigationBar und grundlegende Navigation',
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
  }); */

  testWidgets('FeedPage', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PostPage(Post(
        title: 'Titel',
      )),
    ));
    await expectLater(
        find.byType(PostPage), matchesGoldenFile("feed_page.png"));
  });

  // TODO Navigator doesn't work in Widget Tests - Use driver tests
/* 
  testWidgets('"Über uns" Seite', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    await tester.tap(find.text('Über uns'));
    await tester.pump();

    expect(find.text('Über uns'), findsNWidgets(2));

    expect(find.text('Forderungen ✊'), findsOneWidget);

    expect(find.text('Wichtige Links'), findsOneWidget);
    expect(find.text('Sonstiges'), findsOneWidget);

    await tester.tap(find.text('Verhalten auf Demos 📣'));
    await tester.pump(Duration(milliseconds: 50));

    expect(find.text('Verhalten auf Demos'), findsOneWidget);

    expect(find.text('Impressum'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump(Duration(milliseconds: 50));

    expect(find.text('Impressum 📖'), findsOneWidget);
  }); */
}
