import 'package:app/app.dart';
import 'package:app/widget/title.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class ChallengePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home-Challenges'),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            _beeChallenge(
              'c7',
              'Lol die Lufthansa!',
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.body1,
                  children: <TextSpan>[
                    TextSpan(text: 'Alle Städte Berlins mit Solaranlagen bedenken? 11.056.511 Kitaplätze schaffen? 1.113.861.368 Liter Bier kaufen? Nein die Regierung möchte mit dem Steuergeld nicht der Gesellschaft helfen, sondern Lufthansa retten! Nicht mit uns! Teile über '),
                    TextSpan(
                      text: 'lufthansa.lol', 
                      style: TextStyle(color: Colors.blue[800], decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () { launch('https://lufthansa.lol'); },
                      ),
                    TextSpan(text: ' mit deinen Freunden, was du mit 9 Milliarden Euro für die Gesellschaft machen würdest!'),
                  ],
                ),
              ),
            ),
            _beeChallenge(
              'c8',
              'Ein Stern für Ölkonzerne',
              Text('Öl-Konzerne zerstören unsere Zukunft! Lasst uns das deutlich machen, indem wir enttäuschte Bewertung auf Google hinterlassen. #oilmustfall. Nimm dir 30 Sekunden Zeit um nach den Büros zu suchen und sag ihnen mit uns zusammen deine Meinung!'),
            ),
            _beeChallenge(
              'c9',
              '#WirBildenZukunft',
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.body1,
                  children: <TextSpan>[
                    TextSpan(text: 'In der Schule wird nicht ausreichend über die Klimakrise unterrichtet. Deswegen streiken wir nicht nur, sondern bilden uns alle weiter! Auf YouTube gibt es tolle Webinare rund um das Thema Klimagerechtigkeit. Bilde dich mit uns zusammen und schaue dir ein Video auf unserem '),
                    TextSpan(
                      text: 'Youtube-Kanal', 
                      style: TextStyle(color: Colors.blue[800], decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () { launch('https://www.youtube.com/channel/UCZwF7J5rbyJXBZMJrE_8XCA'); },
                      ),
                    TextSpan(text: ' an!'),
                  ],
                ),
              ),
            ),
            _beeChallenge(
              'c1',
              'Der Picasso in dir!',
              Text('Überlege dir eine Kunstaktion, ob Bild, Knete, Basteln oder Lego mit der du dein Klimathema repräsentierst. Ob klimaneutrales Haus, demonstrierende Menschen, ein Windrad oder eine Kuh, deiner Kreativität sind keine Grenzen gesetzt.'),
            ),
            _beeChallenge(
              'c10',
              'InstagramStory für die Zukunft',
              Text('Hast du schon die Challenge “Schreib deine eigene Zukunfts-Story” unter NetzStreik ausprobiert? Lasst uns verbreiten, wie wir unsere Zukunft sehen!'),
            ),
            _beeChallenge(
              'c6',
              'Challenge & More',
              Text('Erfinde deine eigene Challenge und poste sie unter #appchallengeforfuture oder #challengeforfuture. Sei dabei möglichst kreativ und denk dabei an die Prinzipien von FFF. Diese kannst du auch nochmal in der App nachlesen!'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _beeChallenge(String id, String title, Widget text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleWidget(
          title,
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    Hive.box('challenges')
                        .put(id, !(Hive.box('challenges').get(id) ?? false));
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image.asset(
                      (Hive.box('challenges').get(id) ?? false)
                          ? 'assets/images/bee.png'
                          : 'assets/images/bee_grey.png',
                      height: 60,
                      width: 60),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    text,
                    if (!(Hive.box('challenges').get(id) ?? false))
                      RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            setState(() {
                              Hive.box('challenges').put(id, true);
                            });
                          },
                          child: Text('Erledigt')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
