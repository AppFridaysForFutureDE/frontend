import 'package:app/app.dart';
import 'package:app/widget/title.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends StatelessWidget {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('👤 App Kanäle'),
      ),
      body: ListView(
        children: <Widget>[
          Semantics(
            child: TitleWidget('App Kanäle'),
            label: 'App Kanäle. Bereichsüberschrift',
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.twitter),
              hidden: true,
            ),
            title: Text('Twitter'),
            onTap: () {
              _launchURL('https://twitter.com/future_app');
            },
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.instagram),
              hidden: true,
            ),
            title: Text('Instagram'),
            onTap: () {
              _launchURL('https://www.instagram.com/appforfuture/');
            },
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.facebook),
              hidden: true,
            ),
            title: Text('Facebook'),
            onTap: () {
              _launchURL('https://www.facebook.com/appforfuture');
            },
          ),
        ],
      ),
    );
  }
}
