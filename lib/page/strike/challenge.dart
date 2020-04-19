import 'package:app/app.dart';
import 'package:app/widget/title.dart';

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
              'c1',
              'Der Picasso in dir!',
              'Überlege dir eine Kunstaktion, ob Bild, Knete, Basteln oder Lego mit der du dein Klimathema repräsentierst. Ob klimaneutrales Haus, demonstrierende Menschen, ein Windrad oder eine Kuh, deiner Kreativität sind keine Grenzen gesetzt.',
            ),
            _beeChallenge(
              'c2',
              'We’re staying Home!',
              'Bastel dir ein Streikschild oder ein Banner, oder nimm ein vorhandenes Banner und hänge es gut sichtbar an deinen Balkon oder stelle es vor die Tür! Lass dir dabei von deinen Eltern helfen! Wenn du Hilfe mit einem Spruch brauchst, check unser Social Media! What do we want? Climate Justice!',
            ),
            _beeChallenge(
              'c3',
              'We’re all in this together!',
              'Mit wem hast du lange nicht mehr gesprochen, obwohl du es dir vorgenommen hast? Suche dir drei Personen aus deinem Handy und ruf Sie doch einfach mal an! Wir müssen alle zusammenhalten und einander helfen!',
            ),
            _beeChallenge(
              'c4',
              'Der grüne Daumen',
              'Checke, ob alle Pflanzen im Haus oder im Garten gegossen sind und gieße diese nach Bedarf. Ob deine Pflanzen Wasser brauchen, überprüfst du am besten, indem du mit einem Finger checkst wie trocken die Erde ist. Bist du dir nicht sicher wie viel Wasser die Pflanzen brauchen, frag am besten deine Eltern oder suche kurz im Internet. Und denk daran, weniger ist mehr! ',
            ),
            _beeChallenge(
              'c5',
              'But how is it made?',
              'Such dir ein Kleidungsstück, ein Lebensmittel oder einen Gegenstand in deinem Haus und recherchiere wie dieses produziert worden ist. Ist das Ganze umweltfreundlich? Wie sieht es mit Plastikverpackung aus? Kommt das ganze aus einem europäischen Land oder ist es noch weiter gereist? Wie könnte das ganze klimaneutral gestaltet werden? Wenn du nicht weiter weißt, frag deine Eltern!',
            ),
            _beeChallenge(
              'c6',
              'Challenge & More',
              'Erfinde deine eigene Challenge und poste sie unter #appchallengeforfuture oder #challengeforfuture. Sei dabei möglichst kreativ und denk dabei an die Prinzipien von FFF. Diese kannst du auch nochmal in der App nachlesen!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _beeChallenge(String id, String title, String text) {
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                    (Hive.box('challenges').get(id) ?? false)
                        ? 'assets/images/bee.png'
                        : 'assets/images/bee_grey.png',
                    height: 60,
                    width: 60),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(text),
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
