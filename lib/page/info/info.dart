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
The og info page shows information for all subscribed local groups
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
              onTap: _goToMap,
            ),
            ListTile(
              leading: Semantics(child: Icon(Icons.search)),
              title: Text('oder verwende die Suchfunktion'),
              onTap: () {
                setState(() {
                  searchActive = true;
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
        cursorColor: Theme.of(context).colorScheme.onSurface,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
            hintText: 'Suchen',
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSurface)),
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

  void _goToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage(ogs)),
    ).then((_value) => setState(() {
          refreshSubscribedOgs();
        }));
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
                  onPressed: _goToMap,
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
