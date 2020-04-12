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
            title: Text('Twitter'),
            onTap: () {
                _launchURL('https://twitter.com/FridayForFuture');
              },
          ),
          ListTile(
            title: Text('Instagram'),
            onTap: () {
                _launchURL('https://www.instagram.com/fridaysforfuture.de');
              },
          ),
          ListTile(
            title: Text('Facebook'),
            onTap: () {
                _launchURL('https://www.facebook.com/fridaysforfuture.de/');
              },
          ),
          ListTile(
            title: Text('Flickr'),
            onTap: () {
                _launchURL('https://www.flickr.com/people/146245435@N02/');
              },
          ),
          ListTile(
            title: Text('YouTube'),
            onTap: () {
                _launchURL('https://www.youtube.com/channel/UCZwF7J5rbyJXBZMJrE_8XCA');
              },
          ),
          ListTile(
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://t.me/FridaysForFutureDE');
              },
          ),
          TitleWidget('Diskussions- / Gruppen'),
          ListTile(
            title: Text('Whats App'),
            onTap: () {
                _launchURL('https://chat.whatsapp.com/DlXVuh9KXx10B5LXi7MvsL');
              },
          ),
          ListTile(
            title: Text('Telegram'),
            onTap: () {
                _launchURL('https://t.me/fffDiskussion');
              },
          ), 
          ListTile(
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