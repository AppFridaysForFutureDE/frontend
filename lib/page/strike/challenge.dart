import 'package:app/app.dart';

class ChallengePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In Home Challenge'),
      ),
      body: ListView(
        children: [
          _beeChallenge(
            'c1',
            'Der Picasso in dir!',
            'Überlege dir eine Kunstaktion, ob Bild, Knete, Basteln oder Lego mit der du dein Klimathema repräsentierst. Ob klimaneutrales Haus, demonstrierende Menschen ein Windrad oder eine Kuh, deiner Kreativität sind keine Grenzen gesetzt.',
          ),
          _beeChallenge(
              'c2',
              'Kreiere ein neues Streikschild mit einem außergewöhnlichen Spruch.',
              'Bastel dir ein Streikschild oder ein Banner, oder nimm ein vorhandenes Banner und hänge es gut sichtbar an deinen Balkon oder stelle es vor die Tür! Lass dir dabei von deinen Eltern helfen! Wenn du Hilfe mit einem Spruch brauchst, check unser Social Media! What do we want? Climate Justice!'),
        ],
      ),
    );
  }

  Widget _beeChallenge(String id, String title, String text) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset('assets/images/bee_grey.jpg',
                  height: 60, width: 60),
            ),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {}, // TODO
                child: Text('Erledigt')),
          ],
        ),
        Text(text),
      ],
    );
  }
}
