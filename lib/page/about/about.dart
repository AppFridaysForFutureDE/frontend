import 'package:app/app.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Über uns'),
      ),
      body: Center(
        child: Text(
          'Über die Bewegung und allgemeines',
        ),
      ),
    );
  }
}
