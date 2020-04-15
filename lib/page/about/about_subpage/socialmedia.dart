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
        title: Text('Social Media'),
      ),
      body: ListView(
        children: <Widget>[
          TitleWidget('Social Media Kanäle'),
          ListTile(
            leading: Icon(MdiIcons.twitter, color: Color(0xff387245)),
            title: Text('Twitter'),
            onTap: () {
                _launchURL('https://twitter.com/FridayForFuture');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.instagram, color: Color(0xff387245)),
            title: Text('Instagram'),
            onTap: () {
                _launchURL('https://www.instagram.com/fridaysforfuture.de');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.facebook, color: Color(0xff387245)),
            title: Text('Facebook'),
            onTap: () {
                _launchURL('https://www.facebook.com/fridaysforfuture.de/');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.flickr, color: Color(0xff387245)),
            title: Text('Flickr'),
            onTap: () {
                _launchURL('https://www.flickr.com/people/146245435@N02/');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.youtube, color: Color(0xff387245)),
            title: Text('YouTube'),
            onTap: () {
                _launchURL('https://www.youtube.com/channel/UCZwF7J5rbyJXBZMJrE_8XCA');
              },
          ),
          ListTile(
            leading: Icon(MdiIcons.telegram, color: Color(0xff387245)),
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://t.me/FridaysForFutureDE');
              },
          ),
          TitleWidget('Diskussions- / Gruppen'),
          ListTile(
            leading: Icon(MdiIcons.telegram),
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://t.me/fffDiskussion');
              },
          ), 
          ListTile(
            leading: Icon(MdiIcons.discord, color: Color(0xff387245)),
            title: Text('Discord'),
            onTap: () {
                _launchURL('https://discord.gg/UEGyyrT');
              },
          ),
        ],
      ),
      );
  }
}