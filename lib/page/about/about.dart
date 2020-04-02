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

  _AboutPageState() {
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

  Widget _buildListTile(String name, String slug) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostPage(
                Post.slug(slug),
                isPost: false,
                name: name,
              ),
            ));
      },
    );
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
              title: Text('🗣 Demosprüche'),
              onTap: () {
                Navigator.push(
                  context,
                  //Pushes the Sub Page on the Stack
                  MaterialPageRoute(builder: (context) => DemoPage()),
                );
              },
            ),*/

            _buildListTile('✊ Forderungen', 'forderungen'),
            _buildListTile('🌍 Selbstverständnis', 'selbstverstaendnis'),
            _buildListTile('📣 Verhalten auf Demos', 'verhalten-auf-demos'),
            TitleWidget('Wichtige Links'),
            ListTile(
              title: Text('🌐 Website'),
              onTap: () {
                _launchURL('https://fridaysforfuture.de');
              },
            ),
            TitleWidget('Sonstiges'),
            _buildListTile('📖 Impressum', 'impressum'),
          ],
        ),
      ),
    );
  }
}
