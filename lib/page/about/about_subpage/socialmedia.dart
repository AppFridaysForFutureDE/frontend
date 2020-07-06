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
          TitleWidget('Social Media Kanäle'),
          ListTile(
            leading: Icon(MdiIcons.twitter),
            title: Text('Twitter'),
            onTap: () {
                _launchURL('https://fffutu.re/appTwitter');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.instagram),
            title: Text('Instagram'),
            onTap: () {
                _launchURL('https://fffutu.re/appInstagram');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.facebook),
            title: Text('Facebook'),
            onTap: () {
                _launchURL('https://fffutu.re/appFacebook');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.flickr),
            title: Text('Flickr'),
            onTap: () {
                _launchURL('https://fffutu.re/appFlickr');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.youtube),
            title: Text('YouTube'),
            onTap: () {
                _launchURL('https://fffutu.re/appYouTube');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.telegram),
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://fffutu.re/appTelegramDE');
              },
          ),
          TitleWidget('Diskussions- / Gruppen'),
          ListTile(
            leading: Icon(MdiIcons.telegram),
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://fffutu.re/appTelegramDisk');
              },
          ), 
          ListTile(
            leading: Icon(MdiIcons.discord),
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