import 'package:app/app.dart';
import 'package:app/page/about/about-subpage/demo.dart';
import 'package:app/page/about/about-subpage/forderungen.dart';
import 'package:app/page/about/about-subpage/impressum.dart';
import 'package:app/page/about/about-subpage/selbstvertaendnis.dart';
import 'package:app/page/about/about-subpage/verhalten.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final TextStyle _styleSubHeading =  TextStyle(
    letterSpacing: 3,
    color: Colors.black54,
  );
  final Color _colorSubHeadingBackground = Colors.grey[100];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Über uns'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Material(
              color: _colorSubHeadingBackground,
              child: Text(
                'Die Bewegung',
                style: _styleSubHeading,
              ),
            ),
            ListTile(
              title: Text('Demosprüche 🗣'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DemoPage()),
                );
              },
            ),
            ListTile(
              title: Text('Forderungen✊'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForderungenPage()),
                );
              },
            ),
            ListTile(
              title: Text('Selbstverständnis🥰'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelbstvertaendnisPage()),
                );
              },
            ),
            ListTile(
              title: Text('Verhalten auf Demos📣'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VerhaltenPage()),
                );
              },
            ),
            Material(
              color: _colorSubHeadingBackground,
              child: Text(
                'Wichtige Links',
                style: _styleSubHeading,
              ),
            ),

            ListTile(
              title: Text('Website🌐'),
            ),
            ListTile(
              title: Text('Spenden💵'),
            ),
            Material(
              color: _colorSubHeadingBackground,
              child: Text(
                'Sonstiges',
                style: _styleSubHeading,
              ),
            ),
            ListTile(
              title: Text('Impressum📖'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImpressumPage()),
                );
              },
            ),

          ],
        ),

      ),
    );
  }
}
