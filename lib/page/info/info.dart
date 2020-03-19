import 'package:app/app.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aktuelle Infos'),
      ),
      body: Center(
        child: Text(
          'Die Infos Seite',
        ),
      ),
    );
  }
}
