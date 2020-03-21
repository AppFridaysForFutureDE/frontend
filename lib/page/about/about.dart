import 'package:app/app.dart';
import 'package:app/page/about/about_subpage/about_subpage.dart';
import 'package:app/page/about/about_subpage/demo.dart';

//import 'package:url_launcher/url_launcher.dart';

/*
The About Page
 */
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  /*
  The style of the Sub Headings.
   */
  final TextStyle _styleSubHeading =  TextStyle(
    letterSpacing: 3,
    color: Colors.black54,
  );


  /*
  The Background of the Sub headings
   */
  final Color _colorSubHeadingBackground = Colors.grey[100];
  @override
 /* _launchURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/
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
                  //Pushes the Sub Page on the Stack
                  MaterialPageRoute(builder: (context) => DemoPage()),
                );
              },
            ),
            ListTile(
              title: Text('Forderungen✊'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutSubpage('Forderungen', Text('Unsere Forderungen'))),
                );
              },
            ),
            ListTile(
              title: Text('Selbstverständnis🥰'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutSubpage('Selbstvertändnis', Text('Selbstverständnissssssss'))),
                );
              },
            ),
            ListTile(
              title: Text('Verhalten auf Demos📣'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutSubpage('Verhalten auf Demos', Text('Hier kommt ein toller Text über tolle Demos'))),
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
                  MaterialPageRoute(builder: (context) => AboutSubpage('Impressum', Text('Gaaaaanz viel Impressum .... '))),
                );
              },
            ),

          ],
        ),

      ),
    );
  }
}
