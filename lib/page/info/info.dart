import 'package:app/app.dart';
import 'package:app/widget/og_tile.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}
/*
The Page Shows the Information to all marked OGs
 */
class _InfoPageState extends State<InfoPage> {

  List<OG> ogL;
  _InfoPageState(){
    //Dummy Data
    ogL = [
      _cOG('123','Kieler OG 1','Kiel','Schleswig Holstein', 22223344344,7766767877,'Pleeeenumm ist wichtig für ...', 'https://facebook.com','https://instagram.com','https://twitter.com/','https://fridaysforfuture.de'),
      _cOG('123566','Kieler OG 2','Kiel','Schleswig Holstein', 22223344344,7766767877,'Pleeeenumm ist wichtig für ...', 'https://facebook.com','https://instagram.com','twitter.com/','https://fridaysforfuture.de'),
      _cOG('123566','München zu faul zum eintragen',null,'Bayern', 22223344344,7766767877,null, 'https://facebook.com',null,'https://twitter.com','https://fridaysforfuture.de'),
    ];
  }
  //Only to create the Dummy data
  static OG _cOG(String id, String name, String stadt, String bundesland, num long, num lat, String zusatzinfo,  String facebook,String instagram,String twitter,String website){
    OG og = OG();
    og.id = id;

    og.name = name;
    og.stadt = stadt ;
    og.bundesland = bundesland;

    og.long = long;
    og.lat = lat;

    og.zusatzinfo = zusatzinfo;

    og.facebook = facebook;
    og.instagram = instagram;
    og.twitter = twitter;
    og.website = website;
    return og;
  }
  //the main Build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ortsgruppen Infos'),
      ),
      body: Center(
        child: ListView.builder( // a Standard List View
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          itemCount: ogL.length,
          itemBuilder: (context, index) => OgTile(ogL[index]), //creates a OgTile from an Og

        )
      ),
    );
  }
}
