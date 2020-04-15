import 'package:app/app.dart';

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
          children: <Widget>[
            _buildCard(
              'Ich streike hier!',
              'Zeig allen, dass du weiterstreikst und nach wie vor effektive Schutzmaßnahmen für die Zukunft unseres Planeten forderst. Klick den Button! Trag dich ein! Lade ein Bild hoch, falls du willst, und fülle die Karte als ein Teil der Bewegung.',
              'local',
              Color(0xffadecfe),
              () {
                // Tu was
              },
            ),
            _buildCard(
              'ZukunftsStory',
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
              'Home Challenges',
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
    return FlipCard(
      direction: FlipDirection.HORIZONTAL, // default
      front: Container(
        padding: const EdgeInsets.all(8),
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
    );
  }
}
