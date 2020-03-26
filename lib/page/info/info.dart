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
  bool _isSearch = false;
  String _searchInput = "";
  List<OG> ogAllL;
  List<OG> ogL;
  _InfoPageState(){
    //Dummy Data
    ogAllL = [
      _cOG('123','Kieler OG 1','Kiel','Schleswig Holstein', 22223344344,7766767877,'Pleeeenumm ist wichtig für ... München', 'https://facebook.com','https://instagram.com','https://twitter.com/','https://fridaysforfuture.de'),
      _cOG('123566','Kieler OG 2','Kiel','Schleswig Holstein', 22223344344,7766767877,'Pleeeenumm ist wichtig für ...', 'https://facebook.com','https://instagram.com','twitter.com/','https://fridaysforfuture.de'),
      _cOG('123566','München zu faul zum eintragen',null,'Bayern', 22223344344,7766767877,"Plenum ist wichtig für ... ", 'https://facebook.com',null,'https://twitter.com','https://fridaysforfuture.de'),
    ];
    ogL = ogAllL;

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
  /*
  The filter function returns true if the og SCHOULD NOT be in the shown Result in first Priority
  Else return false if the OG schould be in the REsult of the Search
  Need to be adjusted when the OG class changes
   */
  bool _removeIf(OG og){
    if(og.name != null && (og.name.toLowerCase().contains(_searchInput.toLowerCase()))){
      return false;
    }
    if(og.stadt != null && (og.stadt.toLowerCase().contains(_searchInput.toLowerCase()))){
      return false;
    }
    if(og.bundesland != null && (og.bundesland.toLowerCase().contains(_searchInput.toLowerCase()))){
      return false;
    }
    return true;
  }

  /**
   * This is the second Priority Search
   * It Searches the zusatzinfo and returns false if the zusatzinfo contains the search input
   * Else if the string is not in the zusatzinfo it returns true
   * this list gets appended to the first result because its less relevant then a direct match with the name/city name
   */
  bool _removeSecondPriority(OG og){
    if(og.zusatzinfo != null && (og.zusatzinfo.toLowerCase().contains(_searchInput.toLowerCase()))){
      return false;
    }
    return true;
  }
  //the main Build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearch
          ?AppBar( // With active Search
            title: TextField(
              autofocus: true,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              onChanged: (searchInputP) {
                setState(() {
                  _searchInput = searchInputP;
                  ogL = [];
                  ogL.addAll(ogAllL); // copies the List in order to not currupt the All list
                  ogL.removeWhere(_removeIf);
                  List<OG> secondPriority = [];
                  secondPriority.addAll(ogAllL);
                  secondPriority.removeWhere((og) => (!_removeIf(og))); //creates a list with all the removed OGs
                  secondPriority.removeWhere(_removeSecondPriority); // then filtes all the second Priority
                  ogL.addAll(secondPriority);
                });
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: (){setState(() {
                  ogL = ogAllL;
                  _isSearch = !_isSearch;
                });},
              )
            ],
          )
          :AppBar( // with no Search active
            title: Text('Ortsgruppen Infos'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){setState(() {
                  _isSearch = !_isSearch;
                });},
          )
        ],
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
