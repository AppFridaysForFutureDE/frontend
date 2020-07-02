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
  
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildWidget(String name, String slug) {
    return CupertinoButton(
      child: Text('Jetzt mitmachen!'),
      onPressed: () {
        _launchURL('https://fridaysforfuture.de/kohle/');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Netzstreik'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network('https://fridaysforfuture.de/wp-content/uploads/2020/06/cropped-KohleKoalition-websitebanner.png', alignment: Alignment.topCenter),
            Container(
              child: Text('Am 3. Juli soll im Bundestag das sogenannte "Kohleausstiegsgesetz" beschlossen werden. Dieses Gesetz ist eine Katastrophe und schlägt all unsere Forderungen in den Wind. Echter Klimaschutz wird mit dem Gesetz unmöglich!', textAlign: TextAlign.justify),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              ),
            Container(
              child: Text('Mach jetzt mit und rufe deinen Abgeordneten an!', style: TextStyle(fontWeight: FontWeight.bold)),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            _buildWidget('Keine Kohle für die Kohle!', 'kohle')
            /*_buildCard(
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
            ),*/
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
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 32.0,
                    ),
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(subtitle),
                    ),
                  ),
                  FlatButton(
                    child: const Text('JETZT MITMACHEN'),
                    onPressed: onClickStart,
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
