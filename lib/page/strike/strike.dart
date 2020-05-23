import 'package:app/app.dart';
import 'package:app/page/strike/html_strike_page.dart';
import 'package:app/page/strike/map-netzstreik/add-iframe-page.dart';

import 'package:app/page/strike/map-netzstreik/map-netzstreik.dart';

import 'package:flip_card/flip_card.dart';
import 'future_story.dart';

import 'challenge.dart';

class StrikePage extends StatelessWidget {
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
              'Public Climate School',
              'Die Public Climate School ist da! Mit spannenden Workshops und Vorlesungen bringen wir Studierende, Professoren und Wissenschaftler mit DIR zusammen, um die Wissenschaft hinter der Klimakrise zu erkunden.',
              'local',
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
