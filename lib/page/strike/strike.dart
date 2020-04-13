import 'package:app/app.dart';

class StrikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Netzstreik'),
      ),
      body: ListView(
        children: <Widget>[
          _buildCard('Online Streik', 'Jetzt Foto hochladen und mitmachen!'),
          _buildCard('Zukunft Online', 'Instagram'),
          _buildCard('Challenge', 'Lust auf eine kleine Herausforderung? Mach mit!'),
        ]
      ),
    );
  }

 Widget _buildCard(String title, String subtitle) {
    return Card(
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
                onPressed: () {/* ... */},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
