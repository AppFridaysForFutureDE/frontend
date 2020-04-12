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
  @override
  void initState() {
    super.initState();
    ogAllL = Hive.box('subscribed_ogs').values.toList().cast<OG>();
    ogL = ogAllL;
  }

  /*
  The filter function returns true if the og SCHOULD NOT be in the shown Result in first Priority
  Else return false if the OG schould be in the REsult of the Search
  Need to be adjusted when the OG class changes
   */
  bool _removeIf(OG og) {
    if (og.name != null &&
        (og.name.toLowerCase().contains(_searchInput.toLowerCase()))) {
      return false;
    }
    if (og.name != null &&
        (og.name.toLowerCase().contains(_searchInput.toLowerCase()))) {
      return false;
    }
    if (og.bundesland != null &&
        (og.bundesland.toLowerCase().contains(_searchInput.toLowerCase()))) {
      return false;
    }
    return true;
  }

  /*
   * This is the second Priority Search
   * It Searches the zusatzinfo and returns false if the zusatzinfo contains the search input
   * Else if the string is not in the zusatzinfo it returns true
   * this list gets appended to the first result because its less relevant then a direct match with the name/city name
   */
  bool _removeSecondPriority(OG og) {
    /*   if(og.zusatzinfo != null && (og.zusatzinfo.toLowerCase().contains(_searchInput.toLowerCase()))){
      return false;
    } */
    return true;
  }

  //the main Build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearch
          ? AppBar(
              // With active Search
              title: TextField(
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                onChanged: (searchInputP) {
                  setState(() {
                    _searchInput = searchInputP;
                    ogL = [];
                    ogL.addAll(
                        ogAllL); // copies the List in order to not currupt the All list
                    ogL.removeWhere(_removeIf);
                    List<OG> secondPriority = [];
                    secondPriority.addAll(ogAllL);
                    secondPriority.removeWhere((og) => (!_removeIf(
                        og))); //creates a list with all the removed OGs
                    secondPriority.removeWhere(
                        _removeSecondPriority); // then filtes all the second Priority
                    ogL.addAll(secondPriority);
                  });
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      ogL = ogAllL;
                      _isSearch = !_isSearch;
                    });
                  },
                )
              ],
            )
          : AppBar(
              // with no Search active
              title: Text('Ortsgruppen Infos'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearch = !_isSearch;
                    });
                  },
                )
              ],
            ),
      body: ogL.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  _isSearch
                      ? 'Keine Ergebnisse'
                      : 'Du hast aktuell keine OGs abonniert. OGs lassen sich auf der Karte finden und abonnieren.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              // a Standard List View
              //  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              itemCount: ogL.length,
              itemBuilder: (context, index) =>
                  OgTile(ogL[index]), //creates a OgTile from an Og
            ),
    );
  }
}
