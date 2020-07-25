import 'package:app/app.dart';
import 'package:app/page/strike/html_strike_page.dart';
import 'package:app/page/strike/map-netzstreik/add-iframe-page.dart';

import 'package:app/page/strike/map-netzstreik/map-netzstreik.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/rendering.dart';
import 'future_story.dart';

import 'challenge.dart';

import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';

import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class StrikePage extends StatefulWidget {
  @override
  _StrikePageState createState() => _StrikePageState();
}

class _StrikePageState extends State<StrikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Netzstreik'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildCard(
              '#WirBildenZukunft',
              'Wir schwänzen nicht! Wir sitzen nicht auf der Couch! Wir bilden uns - über die Lösungen unserer Zukunft! Hier findest du Vorträge von Wissenschaftler*innen, die DU dir live von überall aus ansehen kannst!',
              'wirbildenzukunft',
              Color(0xffadecfe),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HtmlStrikePage()),
                );
              },
            ),
            _buildCard(
              'Zukunfts-Story',
              'Die Zukunft, ein Traum den jede*r hat. Doch die Klimakrise bringt ebenjene in Gefahr... Die Zeit etwas zu ändern ist jetzt! Fülle die Vorlage für die Story aus und tagge drei deiner Freunde. Hilf uns dabei, awareness zu spreaden und die Zukunft zu retten!',
              'story',
              Color(0xff95d686),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FutureStoryPage()),
                );
              },
            ),
            _buildCard(
              'Home-Challenges',
              'Wir brauchen dein Köpfchen! Mit diesen Challenges kannst du dich mit einfachen Hausutensilien stark fürs Klima machen, also streng die grauen Zellen für eine grüne Zukunft an.',
              'challenge',
              Color(0xfffff0a5),
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChallengePage()),
                );
              },
            ),
          ]),
    );
  }

  Widget _buildCard(String title, String subtitle, String imageName,
      Color cardColor, Function onClickStart) {
    return Expanded(
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL, // default
        front: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                'assets/images/$imageName.jpg',
                semanticLabel: 'Bild. Bitte tippen zum Ansehen des jeweiligen Netzstreiks',
              ),
            ),
          ),
        ),
        back: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Align(
            alignment: Alignment.center,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 12,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Expanded(
                          child: LayoutBuilder(builder: (context, size) {
                            // Virtuelles Rendern einer Textzeile, um die Zeilenhöhe zu berechnen
                            final span = TextSpan(
                                text: 'Test',
                                style: Theme.of(context).textTheme.bodyText2);

                            TextPainter tp = TextPainter(
                                text: span, textDirection: TextDirection.ltr);
                            tp.layout(
                              maxWidth: 100,
                            );

                            return Text(
                              subtitle,
                              maxLines: (size.maxHeight / tp.height)
                                  .floor(), // Verfügbare Höhe wird durch Höhe einer Textzeile geteilt, um maximal passende Anzahl an Zeilen zu erhalten
                              overflow: TextOverflow.ellipsis,
                            );
                          }),
                        ),
                        SizedBox(
                          // Platzhalter für den "JETZT MITMACHEN" Button
                          height: 28,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: FlatButton(
                      padding: const EdgeInsets.all(0),
                      child: const Text('JETZT MITMACHEN'),
                      onPressed: onClickStart,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
