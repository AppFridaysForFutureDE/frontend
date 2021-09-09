import 'package:app/model/post.dart';
import 'package:app/page/about/settings.dart';
import 'package:app/page/feed/post.dart';
import 'package:app/util/navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/app.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'about_subpage/demo.dart';
import 'about_subpage/socialmedia.dart';

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

  Widget _buildButton(String assetName, Function click) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: IconButton(
          onPressed: () {
            click();
          },
          icon: SvgPicture.asset(
            'assets/infoicons/' + assetName + '.svg',
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
          ),
          highlightColor: Theme.of(context).backgroundColor,
          padding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _buildLinkButton(String assetName, String url) {
    return _buildButton(assetName, () => {_launchURL(url)});
  }

  Widget _buildPageButton(String assetName, String slug, String pageShownName) {
    return _buildButton(
        assetName,
        () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      Post.slug(slug),
                      isPost: false,
                      name: pageShownName,
                    ),
                  ))
            });
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
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: IconButton(
                      onPressed: () {
                        NavUtil(context).openLink(
                          'https://app.fffutu.re/forderungen/',
                          true,
                          'Forderungen',
                        );
                      },
                      icon: SvgPicture.asset(
                        'assets/infoicons/Forderungen.svg',
                        alignment: Alignment.center,
                      ),
                      padding: EdgeInsets.all(7.5),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildButton(
                    'Demospruch',
                    () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DemoPage()),
                          )
                        }),
                _buildButton(
                  'Arbeitsgruppe',
                  () {
                    NavUtil(context).openLink(
                      'https://app.fffutu.re/ag-liste/',
                      true,
                      'Arbeitsgruppen',
                    );
                  },
                  /* 'bundesweite-arbeitsgruppen',
                  'Bundesweite Arbeitsgruppen', */
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildLinkButton('Website', 'https://fridaysforfuture.de'),
                _buildLinkButton(
                    'Blog', 'https://fridaysforfuture.de/neuigkeiten/'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildLinkButton(
                    'Social_Instagram', 'https://fffutu.re/appInstagram'),
                _buildLinkButton(
                    'Social_Twitter', 'https://fffutu.re/appTwitter'),
                _buildLinkButton(
                    'Social_Facebook', 'https://fffutu.re/appFacebook'),
                _buildLinkButton(
                    'Social_Youtube', 'https://fffutu.re/appYouTube'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildButton(
                    'Kanale',
                    () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SocialMediaPage()),
                          )
                        }),
                _buildLinkButton(
                    'Github', 'https://github.com/AppFridaysForFutureDE'),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: IconButton(
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
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Schließen'))
                              ],
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/infoicons/Weiteres.svg',
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
