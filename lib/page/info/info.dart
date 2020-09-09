import 'package:app/app.dart';
import 'package:app/page/map/map.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:app/widget/og_tile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

/*
The Page Shows the Information to all marked OGs
 */
class _InfoPageState extends State<InfoPage> {
  List<OG> ogs;
  List<OG> filteredOgs;
  List<OG> subscribedOgs;

  bool searchActive = false;
  String searchText = "";

  @override
  void initState() {
    refreshSubscribedOgs();
    _loadData();

    super.initState();
  }

  void refreshSubscribedOgs() {
    subscribedOgs = Hive.box('subscribed_ogs').values.toList().cast<OG>();
  }

  Future _loadData() async {
    try {
      // ogs = await api.getOGs();
      ogs = await api.getOGs();

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted)
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
    }
  }

  /*
  The filter function returns true if the og SCHOULD NOT be in the shown Result in first Priority
  Else return false if the OG schould be in the REsult of the Search
  Need to be adjusted when the OG class changes
   */
  // bool _removeIf(OG og) {
  //   if (og.name != null &&
  //       (og.name.toLowerCase().contains(searchText.toLowerCase()))) {
  //     return false;
  //   }
  //   if (og.name != null &&
  //       (og.name.toLowerCase().contains(searchText.toLowerCase()))) {
  //     return false;
  //   }
  //   if (og.bundesland != null &&
  //       (og.bundesland.toLowerCase().contains(searchText.toLowerCase()))) {
  //     return false;
  //   }
  //   return true;
  // }

  /*
   * This is the second Priority Search
   * It Searches the zusatzinfo and returns false if the zusatzinfo contains the search input
   * Else if the string is not in the zusatzinfo it returns true
   * this list gets appended to the first result because its less relevant then a direct match with the name/city name
   */
  // bool _removeSecondPriority(OG og) {
  /*   if(og.zusatzinfo != null && (og.zusatzinfo.toLowerCase().contains(searchText.toLowerCase()))){
      return false;
    } */
  //   return true;
  // }

  Widget _emptyBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Hier findest du alle wichtigen Infos rund um die Ortsgruppen, die du abonniert hast.',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50.0),
            Center(
              child: Text(
                'Um Ortsgruppen zu abonnieren:',
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              leading: Semantics(child: Icon(MdiIcons.map)),
              title: Text('schau dich auf der Karte um'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
            ),
            ListTile(
              leading: Semantics(child: Icon(Icons.search)),
              title: Text('oder verwende die Suchfunktion'),
              onTap: () {
                setState(() {
                  searchActive = !searchActive;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchAppBar() {
    return AppBar(
      title: TextField(
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        autocorrect: false,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: 'Suchen', hintStyle: TextStyle(color: Colors.white)),
        onChanged: (s) {
          setState(() {
            searchText = s;
          });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          tooltip: 'Suche schließen',
          onPressed: () {
            setState(() {
              searchActive = !searchActive;
            });
          },
        )
      ],
    );
  }

  Widget _searchBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: filteredOgs.isEmpty
          ? Center(
              child: Text('Keine Ergebnisse'),
            )
          : ListView(
              children: <Widget>[
                for (var og in filteredOgs)
                  ListTile(
                    title: Text(og.name),
                    onTap: () {
                      showOGDetails(og);
                    },
                  )
              ],
            ),
    );
  }

  showOGDetails(OG og) {
    bool subscribed = Hive.box('subscribed_ogs').containsKey(og.ogId);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(og.name),
        content: SocialButtons(og, true),
        actions: <Widget>[
          FlatButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Abbrechen'),
          ),
          subscribed
              ? FlatButton(
                  onPressed: () async {
                    Hive.box('subscribed_ogs').delete(og.ogId);
                    Navigator.of(context).pop();
                    setState(() {
                      refreshSubscribedOgs();
                    });
                    await FirebaseMessaging()
                        .unsubscribeFromTopic('og_${og.ogId}');
                  },
                  child: Text('Deabonnieren'),
                )
              : FlatButton(
                  onPressed: () async {
                    Hive.box('subscribed_ogs').put(og.ogId, og);
                    Navigator.of(context).pop();
                    setState(() {
                      searchActive = false;
                      refreshSubscribedOgs();
                    });
                    await FirebaseMessaging().subscribeToTopic('og_${og.ogId}');
                  },
                  child: Text('Abonnieren'),
                ),
        ],
      ),
    );
  }

  //the main Build function
  @override
  Widget build(BuildContext context) {
    if (searchActive) {
      filteredOgs = ogs
          .where((o) => o.name.toLowerCase().contains(searchText.toLowerCase()))
          .take(100)
          .toList();

      filteredOgs.sort((a, b) =>
          b.name.toLowerCase().startsWith(searchText.toLowerCase()) ? 1 : -1);
    }

    return Scaffold(
      appBar: searchActive
          ? _searchAppBar()
          : AppBar(
              // with no Search active
              title: Text('Ortsgruppen Infos'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.map),
                  tooltip: 'Karte öffnen',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: 'Ortsgruppe suchen',
                  onPressed: () {
                    setState(() {
                      searchActive = !searchActive;
                    });
                  },
                )
              ],
            ),
      body: searchActive
          ? _searchBody()
          : subscribedOgs.isEmpty
              ? _emptyBody()
              : ListView.builder(
                  // a Standard List View
                  //  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  itemCount: subscribedOgs.length,
                  itemBuilder: (context, index) => OgTile(
                      subscribedOgs[index]), //creates a OgTile from an Og
                ),
    );
  }
}
