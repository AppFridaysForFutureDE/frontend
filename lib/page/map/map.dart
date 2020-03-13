import 'package:app/app.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karte'),
      ),
      body: Center(
        child: Text(
          'Hier befindet sich die Karte',
        ),
      ),
    );
  }
}
