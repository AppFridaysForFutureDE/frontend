import 'package:app/widget/og_social_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/app.dart';

/*
A Tile wich displays a OG in  a Scroll View and is extandable
 */
class OgTile extends StatelessWidget {
  OG og;
  /*
  The Contructor takes an og Object
   */
  OgTile(this.og);
  /*
  Launches a URl or throws an Error
   */
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*
  Takes a icon and a url String
  and Builds a Row with a Icon and a social Media Link which is clickable
   */

  /*
  Builds the Location Text Widgets
  Depending on which filds are set
   */
  Widget _buildLocation() {
    if (og.name == null || og.name == '') {
      if (og.bundesland == null || og.bundesland == '') {
        return SizedBox();
      }
      return Text(og.bundesland);
    }
    if (og.bundesland == null || og.bundesland == '') {
      return Text(og.name);
    }
    return Text(og.name + ' - ' + og.bundesland);
  }

  /*
  The Main Build Method
   */
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        og.name,
        style: Theme.of(context).textTheme.title,
      ),
      children: <Widget>[
        _buildLocation(),
        OGSocialButtons(og, false),
      ],
    );
  }
}
