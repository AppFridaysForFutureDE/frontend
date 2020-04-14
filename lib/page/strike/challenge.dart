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
          Text(
              "Hier sind ein paar richtig coole Ideen, welche du von Zuhause aus erledigen kannst:"),
          _beeChallenge(
              "Poste auf social Media alle Klimamaßnahmen, die du dir von der Politik wünschst."),
          //_beeChallenge(    "Kreiere ein neues Streikschild mit einem außergewöhnlichen Spruch."),
        ],
      ),
    );
  }

  Widget _beeChallenge(String text) {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child:
                  Image.asset('assets/images/bee.png', height: 60, width: 60),
            ),
            RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {}, // TODO
                child: Text("Abschließen")),
          ],
        ),
        Text(text),
      ],
    );
  }
}
