import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/app.dart';
import 'package:app/page/about/about_subpage/about_subpage.dart';
import 'package:app/page/about/about_subpage/demo.dart';
import 'package:app/widget/title.dart';

//import 'package:url_launcher/url_launcher.dart';

/*
The About Page
 */
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Über uns'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            TitleWidget('Die Bewegung'),
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
              title: Text('Forderungen ✊'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutSubpage(
                          'Forderungen', Text('Unsere Forderungen'))),
                );
              },
            ),
            ListTile(
              title: Text('Selbstverständnis 🥰'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutSubpage('Selbstvertändnis',
                          Text('Selbstverständnissssssss'))),
                );
              },
            ),
            ListTile(
              title: Text('Verhalten auf Demos 📣'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutSubpage('Verhalten auf Demos',
                          Text('Hier kommt ein toller Text über tolle Demos'))),
                );
              },
            ),
            TitleWidget('Wichtige Links'),
            ListTile(
              title: Text('Website 🌐'),
              onTap: (){
                _launchURL('https://fridaysforfuture.de');
              },
            ),
            TitleWidget('Sonstiges'),
            ListTile(
              title: Text('Impressum 📖'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutSubpage(
                          'Impressum', Text('Gaaaaanz viel Impressum .... '))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
