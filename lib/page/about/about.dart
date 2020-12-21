import 'package:app/model/post.dart';
import 'package:app/page/about/about_subpage/socialmedia.dart';
import 'package:app/page/about/settings.dart';
import 'package:app/page/feed/post.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/app.dart';
import 'package:app/widget/title.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'about_subpage/demo.dart';

/*
The About Page
 */
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Used to display a svg which opens a new page with the content of a CMS Page
  Widget _buildFlatButton(
      String pageShownName, String slug, String assetName, Color color) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostPage(
                Post.slug(slug),
                isPost: false,
                name: pageShownName,
              ),
            ));
      },
      child: SvgPicture.asset(
        assetName,
        color: color,
        alignment: Alignment.center,
      ),
      padding: EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Über uns'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Einstellungen',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              })
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: _buildFlatButton(
                      'Forderungen',
                      'forderungen',
                      'assets/infoicons/Forderungen.svg',
                      Theme.of(context).backgroundColor),
                  color: Theme.of(context).accentColor,
                  width: double.infinity,
                  height: double.infinity),
            ),
            Expanded(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DemoPage()),
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/infoicons/Demosprueche.svg',
                            color: Theme.of(context).primaryColor,
                            alignment: Alignment.center,
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        color: Theme.of(context).backgroundColor,
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.only(right: 2.5),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            child: _buildFlatButton(
                                'Bundesweite Arbeitsgruppen',
                                'bundesweite-arbeitsgruppen',
                                'assets/infoicons/Arbeitsgruppen.svg',
                                Theme.of(context).primaryColor),
                            color: Theme.of(context).backgroundColor,
                            width: double.infinity,
                            height: double.infinity,
                            margin: EdgeInsets.only(left: 2.5)))
                  ],
                ),
                color: Theme.of(context).accentColor,
              ),
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: () {
                    _launchURL('https://www.helpforfuture.org');
                  },
                  child: SvgPicture.asset(
                      'assets/infoicons/HelpForFutureHell.svg',
                      color: Theme.of(context).backgroundColor),
                ),
                color: Theme.of(context).accentColor,
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).accentColor,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: FlatButton(
                          onPressed: () {
                            _launchURL('https://fridaysforfuture.de');
                          },
                          child: SvgPicture.asset(
                              'assets/infoicons/WebsiteIconhell.svg',
                              color: Theme.of(context).backgroundColor),
                        ),
                        color: Theme.of(context).primaryColor,
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 2.5),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SocialMediaPage()),
                                );
                              },
                              child: SvgPicture.asset(
                                  'assets/infoicons/SocialMediaIconhell.svg',
                                  color: Theme.of(context).backgroundColor),
                            ),
                            color: Theme.of(context).primaryColor,
                            width: double.infinity,
                            height: double.infinity,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 2.5)))
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
                    child: FlatButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Weiteres...'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text('Impressum',
                                      style: TextStyle(fontSize: 18)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PostPage(
                                            Post.slug('impressum'),
                                            isPost: false,
                                            name: 'Impressum',
                                          ),
                                        ));
                                  },
                                ),
                                ListTile(
                                  title: Text('Datenschutz',
                                      style: TextStyle(fontSize: 18)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PostPage(
                                            Post.slug('datenschutz'),
                                            isPost: false,
                                            name: 'Datenschutz',
                                          ),
                                        ));
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Schließen'))
                            ],
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/infoicons/WeiteresIconhell.svg',
                        color: Theme.of(context).accentColor,
                        alignment: Alignment.center,
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                    color: Theme.of(context).backgroundColor,
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(right: 2.5))),
          ],
        ),
      ),
    );
  }
}
