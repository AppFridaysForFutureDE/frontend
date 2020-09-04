import 'package:app/app.dart';
import 'package:app/widget/title.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends  StatelessWidget {

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
        title: Text('👤 Social Media'),
      ),
      body: ListView(
        children: <Widget>[
          Semantics(
            child: TitleWidget('Social Media Kanäle'),
            label: 'Social Media Kanäle. Bereichsüberschrift',
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.twitter),
              hidden: true,
            ),
            title: Text('Twitter'),
            onTap: () {
                _launchURL('https://fffutu.re/appTwitter');
              },
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.instagram),
              hidden: true,
            ),
            title: Text('Instagram'),
            onTap: () {
                _launchURL('https://fffutu.re/appInstagram');
              },
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.facebook),
              hidden: true,
            ),
            title: Text('Facebook'),
            onTap: () {
                _launchURL('https://fffutu.re/appFacebook');
              },
          ),
/*           ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.flickr),
              hidden: true,
            ),
            title: Text('Flickr'),
            onTap: () {
                _launchURL('https://fffutu.re/appFlickr');
              },
          ), */
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.youtube),
              hidden: true,
            ),
            title: Text('YouTube'),
            onTap: () {
                _launchURL('https://fffutu.re/appYouTube');
              },
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.telegram),
              hidden: true,
            ),
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://fffutu.re/appTelegramDE');
              },
          ),
          Semantics(
            child: TitleWidget('Diskussions- / Gruppen'),
            label: 'Diskussionsgruppen. Bereichsüberschrift',
          ),
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.telegram),
              hidden: true,
            ),
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://fffutu.re/appTelegramDisk');
              },
          ), 
          ListTile(
            leading: Semantics(
              child: Icon(MdiIcons.discord),
              hidden: true,
            ),
            title: Text('Discord'),
            onTap: () {
                _launchURL('https://fffutu.re/appDiscord');
              },
          ),
        ],
      ),
      );
  }
}