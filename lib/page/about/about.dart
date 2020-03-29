import 'dart:io';
import 'package:app/model/post.dart';
import 'package:app/page/about/settings.dart';
import 'package:app/page/feed/post.dart';
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
  Post verhalten = null;

  _AboutPageState(){
    //_loadAllSubpages();
  }

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
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              })
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            TitleWidget('Die Bewegung'),
          /*  ListTile(
              title: Text('Demosprüche 🗣'),
              onTap: () {
                Navigator.push(
                  context,
                  //Pushes the Sub Page on the Stack
                  MaterialPageRoute(builder: (context) => DemoPage()),
                );
              },
            ),*/
            ListTile(
              title: Text('Forderungen ✊'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //loads a Post page except that the title is at the Top
                    //the post loaded has the SLUG forderungen
                    builder: (context) => AboutSubpage('forderungen'),
                  )
                );
              },
            ),
            ListTile(
              title: Text('Selbstverständnis 🥰'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AboutSubpage('selbstverstaendnis'),
                  )
                );
              },
            ),
            ListTile(
              title: Text('Verhalten auf Demos 📣'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        if(verhalten != null){
                          return PostPage(verhalten);
                        }else {
                          return AboutSubpage('verhalten-auf-demos'); 
                        }
                      }),
                );
              },
            ),
            TitleWidget('Wichtige Links'),
            ListTile(
              title: Text('Website 🌐'),
              onTap: () {
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
                      builder: (context) => AboutSubpage('impressum'),
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
