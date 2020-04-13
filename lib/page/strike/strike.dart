import 'package:app/app.dart';
import 'package:flip_card/flip_card.dart';
import 'future_story.dart';

class StrikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Netzstreik'),
      ),
      body: Column(children: <Widget>[
        _buildCard(
          'Online Streik',
          'Jetzt Foto hochladen und mitmachen!',
          () {
            // Tu was
          },
        ),
        _buildCard(
          'Zukunft Online',
          'Instagram',
          () {
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FutureStoryPage()),
                );
          },
        ),
        _buildCard(
          'Challenge',
          'Lust auf eine kleine Herausforderung? Mach mit!',
          () {
            // Tu was
          },
        ),
      ]),
    );
  }

  Widget _buildCard(String title, String subtitle, Function onClickStart) {
    return Expanded(
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL, // default
        front: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text(title),
                subtitle: Text(subtitle),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('JETZT STARTEN'),
                    onPressed: onClickStart,
                  ),
                ],
              ),
            ],
          ),
        ),
        back: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Text(title),
                subtitle: Text(subtitle),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('JETZT STARTEN'),
                    onPressed: onClickStart,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
