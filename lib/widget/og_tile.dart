import 'package:url_launcher/url_launcher.dart';

import '../app.dart';
/*
A Tile wich displays a OG
 */
class OgTile extends StatelessWidget{

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
  and Builds a Row with a Icon and a social Media Link
   */
  Widget _buildSocialMedia(IconData icon,String url){
    return (url == null || url == '')
        ? Container()
        : Row(
      children: <Widget>[
        Icon(icon),
        FlatButton(
          onPressed: () => _launchURL(url),
          child: Text(
            url
          )
        )
      ],
    );
  }
  /*
  Builds the Location Text Widgets
  Depending on wich filds are set
   */
  Widget _buildLocation(){
    if(og.stadt == null || og.stadt == ''){
      if(og.bundesland == null || og.bundesland == ''){
        return Container();
      }
      return Text(og.bundesland);
    }
    if(og.bundesland == null || og.bundesland == ''){
      return Text(og.stadt);
    }
    return Text(og.stadt+' - '+og.bundesland);
  }
  /*
  The Main Build Method
   */
  @override
  Widget build(BuildContext context){
    return ExpansionTile(

      title:Text(
        og.name,
        style: Theme.of(context).textTheme.title,
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(30, 0.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              _buildLocation(),
              (og.zusatzinfo == null || og.zusatzinfo == '')? Container() : Text(og.zusatzinfo),
              _buildSocialMedia(MdiIcons.web, og.website),
              _buildSocialMedia(MdiIcons.facebook, og.facebook),
              _buildSocialMedia(MdiIcons.twitter, og.twitter),
              _buildSocialMedia(MdiIcons.instagram, og.instagram),

            ],
          ),
        ),
      ],
    );
  }
}

