import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app.dart';

class OgTile extends StatelessWidget{
  OgTileSave ogSave;
  OG og;
  Function delegateSetState;
  OgTile(this.ogSave, this.delegateSetState){
    og = ogSave.og;
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Widget _buildSocialMedia(IconData icon,String url){
    return (url == null || url == '')
        ? Container()
        : Row(
      children: <Widget>[
        FaIcon(icon),
        FlatButton(
          onPressed: () => _launchURL(url),
          child: Text(
            url
          )
        )
      ],
    );
  }
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
  @override
  Widget build(BuildContext context){
    return ogSave.tapped ?
        Container(

          padding: EdgeInsets.fromLTRB(0.0,15.0,10.0,0.0),
          child: FlatButton(
            onPressed: (){delegateSetState((){
              ogSave.tapped = !ogSave.tapped;
            });},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  og.name,
                  style: Theme.of(context).textTheme.title,
                ),

                _buildLocation(),
                (og.zusatzinfo == null || og.zusatzinfo == '')? Container() : Text(og.zusatzinfo),
                _buildSocialMedia(FontAwesomeIcons.globe, og.website),
                _buildSocialMedia(FontAwesomeIcons.facebookSquare, og.facebook),
                _buildSocialMedia(FontAwesomeIcons.twitterSquare, og.twitter),
                _buildSocialMedia(FontAwesomeIcons.instagram, og.instagram),

              ],
            ),
          ),
        )
    /*ListTile( //expanded version
        title: Text(ogSave.og.name),
        subtitle: Text(ogSave.og.stadt+ ' - '+ogSave.og.bundesland+'\n'+ogSave.og.zusatzinfo +'\n'+'\n'+ogSave.og.facebook),
        isThreeLine: true,
        onTap: (){delegateSetState((){
          ogSave.tapped = !ogSave.tapped;
        });},
    )*/
        : ListTile(
      title: Text(ogSave.og.name),
      onTap: (){delegateSetState((){
        ogSave.tapped = !ogSave.tapped;
      });},
    );
  }
}

class OgTileSave{
  OG og;
  bool tapped = false;
  OgTileSave(this.og);
}