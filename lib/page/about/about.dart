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



/*
How to use this Widget: First parameter: The name of the ListTile, second: name without Emojis (used for screenreaders), third: Name which is shown on the new page (perhaps a bit shorter), fourth: Name of the linked site
*/

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
                child: _buildFlatButton('Forderungen', 'forderungen', 'assets/infoicons/Forderungen.svg', Colors.white),
                color: Color(0xff9ed2ea),
                width: double.infinity,
                height: double.infinity
              )
            ),
            Expanded(
              child: Container (
                child: Row(
                  children: <Widget> [
                    Expanded (
                      child: Container(
                        child: FlatButton (
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DemoPage()),
                          );
                        }, 
                        child: SvgPicture.asset('assets/infoicons/Demosprueche.svg'),
                        ),
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.only(right: 2.5)
                      )
                    ),
                    Expanded (
                      child: Container(
                        child: _buildFlatButton('Bundesweite Arbeitsgruppen', 'bundesweite-arbeitsgruppen', 'assets/infoicons/Arbeitsgruppen.svg', Color(0xff4fa355)),
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                        margin: EdgeInsets.only(left: 2.5)
                      )
                    )
                  ],
                ),
                color: Color(0xff9ed2ea),
              )
            ),
            Expanded(
              child: Container(
                child: FlatButton(
                  onPressed: (){
                    _launchURL('https://www.helpforfuture.org');
                  }, 
                  child: SvgPicture.asset('assets/infoicons/HelpForFutureHell.svg')
                ),
                color: Color(0xff9ed2ea),
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(10),
              )
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: FlatButton(
                        onPressed: (){
                          _launchURL('https://fridaysforfuture.de');
                        }, 
                        child: SvgPicture.asset('assets/infoicons/WebsiteIconhell.svg')
                      ),
                      color: Color(0xff4fa355),
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 2.5)
                    )
                  ),
                  Expanded(
                    child: Container(
                      child: FlatButton (
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SocialMediaPage()),
                          );/*"..\..\assets\infoicons\SocialMediaIconhell.svg"*/
                        }, 
                        child: SvgPicture.asset('assets/infoicons/SocialMediaIconhell.svg')
                      ),
                      color: Color(0xff4fa355),
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 2.5)
                    )
                  )
                ],
              )
            ),
            Expanded(
              child: Container(
                child: _buildFlatButton('Weiteres', 'impressum','assets/infoicons/WeiteresIconhell.svg', Color(0xff9ed2ea)),
                width: double.infinity,
                height: double.infinity
              )
            )
          ]
        )
        /*child: ListView(
          children: <Widget>[
            Semantics(
              label: 'Die Bewegung. Bereichsüberschrift',
              child: TitleWidget('Die Bewegung'),
            ),
            _buildListTile(
                '✊ Forderungen', 'Forderungen', '✊ Forderungen', 'forderungen'),
            _buildListTile('🌍 Selbstverständnis', 'Selbstverständnis',
                '🌍 Selbstverständnis', 'selbstverstaendnis'),
            _buildListTile(
                '✍️ Bundesweite Arbeitsgruppen',
                'Bundesweite Arbeitsgruppen',
                '✍️ Bundesweite AGs',
                'bundesweite-arbeitsgruppen'),
            ListTile(
              title: Text('🗣 Demosprüche'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DemoPage()),
                );
              },
            ),
            _buildListTile('📣 Verhalten auf Demos', 'Verhalten auf Demos',
                '📣 Verhalten auf Demos', 'verhalten-auf-demos'),
            Semantics(
              label: 'Wichtige Links. Bereichsüberschrift',
              child: TitleWidget('Wichtige Links'),
            ),
            ListTile(
              title: Text('🌐 Website'),
              onTap: () {
                _launchURL('https://fridaysforfuture.de');
              },
            ),
            ListTile(
              title: Text('👤 Social Media'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SocialMediaPage()),
                );
              },
            ),
            Semantics(
              label: 'Sonstige. Bereichsüberschrift',
              child: TitleWidget('Sonstiges'),
            ),
            _buildListTile(
                '📖 Impressum', 'Impressum', '📖 Impressum', 'impressum'),
            _buildListTile('📑 Datenschutz', 'Datenschutz', '📑 Datenschutz',
                'datenschutz'),
            Center(
              child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, result) {
                  if (!result.hasData) return SizedBox();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Dies ist die offizielle App von Fridays for Future Deutschland in der Version ${result.data.version}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),*/
      ),
    );
  }
}
