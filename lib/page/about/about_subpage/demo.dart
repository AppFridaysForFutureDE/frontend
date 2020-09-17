import 'dart:developer';
import 'dart:io' show Platform;

import 'package:app/app.dart';
import 'package:app/model/slogan.dart';
import 'package:app/util/share.dart';
import 'package:flutter/cupertino.dart';

import 'demofilter.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    try {
      slogans = await api.getSlogans();
      if (mounted) setState(() {});
    } catch (e, st) {
      if (mounted)
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.'),
          ),
        );
    }
  }

  List<Slogan> slogans;

  bool searchActive = false;
  String searchText = '';

  var filterState = FilterState();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: Hive.box('slogan_mark').isEmpty ? 0 : 1,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: searchActive
              ? TextField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: false,
                  cursorColor: Theme.of(context).colorScheme.onSurface,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                      hintText: 'Suchen',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface)),
                  onChanged: (s) {
                    setState(() {
                      searchText = s;
                    });
                  },
                )
              : Text('Demosprüche', semanticsLabel: 'Demosprüche'),
          actions: <Widget>[
            if (slogans != null)
              if (!searchActive)
                IconButton(
                  icon: Icon(MdiIcons.filter),
                  tooltip: 'Filter Einstellungen',
                  onPressed: () async {
                    var newFilterState = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DemoFilterPage(
                          filterState,
                          slogans.fold<Set>(
                              Set(), (a, b) => a..addAll(b.tags.toList())),
                        ),
                      ),
                    );

                    if (newFilterState != null)
                      setState(() {
                        filterState = newFilterState;
                      });
                  },
                ),
            if (slogans != null)
              IconButton(
                icon: Icon(searchActive ? Icons.close : MdiIcons.magnify,
                    semanticLabel:
                        searchActive ? 'Suche schließen' : 'Im Feed suchen'),
                onPressed: () {
                  setState(() {
                    if (searchActive) {
                      searchText = '';
                      searchActive = false;
                    } else {
                      searchActive = true;
                    }
                  });
                },
              ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Alle Sprüche',
              ),
              Tab(
                text: 'Favoriten',
              ),
            ],
            indicatorWeight: 4,
          ),
        ),
        body: slogans == null
            ? LinearProgressIndicator()
            : TabBarView(
                children: [
                  Column(
                    children: <Widget>[
                      if (filterState.filterActive)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          color: Colors.yellow,
                          alignment: Alignment.center,
                          child: Text(
                            'Es sind Filter aktiv',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Expanded(
                        child: searchActive
                            ? _buildListView(text: searchText.toLowerCase())
                            : _buildListView(),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      if (filterState.filterActive)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          color: Colors.yellow,
                          alignment: Alignment.center,
                          child: Text(
                            'Es sind Filter aktiv',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Expanded(
                        child: searchActive
                            ? _buildListView(
                                text: searchText.toLowerCase(),
                                onlyFavorites: true)
                            : _buildListView(onlyFavorites: true),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildListView({String text, bool onlyFavorites = false}) {
    List<Slogan> shownSlogans = List.from(slogans);

    if (onlyFavorites) {
      var markBox = Hive.box('slogan_mark');
      shownSlogans =
          shownSlogans.where((p) => (markBox.get(p.id) ?? false)).toList();
    }

    if (filterState.filterActive) {
      if (filterState.onlyShowMarked) {
        var markBox = Hive.box('slogan_mark');
        shownSlogans =
            shownSlogans.where((p) => (markBox.get(p.id) ?? false)).toList();
      }
      if (filterState.shownTags.isNotEmpty) {
        shownSlogans = shownSlogans
            .where((p) =>
                p.tags.firstWhere((s) => filterState.shownTags.contains(s),
                    orElse: () => null) !=
                null)
            .toList();
      }
    }

    if (text != null) {
      shownSlogans =
          shownSlogans.where((s) => s.searchText().contains(text)).toList();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: shownSlogans.isEmpty
          ? Center(
              child: Text('Keine Ergebnisse'),
            )
          : ListView.separated(
              itemCount: shownSlogans.length,
              itemBuilder: (context, index) {
                return SloganItem(shownSlogans[index], setState);
              },
              separatorBuilder: (context, index) => Container(
                height: 0.5,
                color: Theme.of(context).hintColor,
              ),
            ),
    );
  }
}

class SloganItem extends StatefulWidget {
  final Slogan item;
  final Function setParentState;

  SloganItem(this.item, this.setParentState);

  @override
  _SloganItemState createState() => _SloganItemState();
}

class _SloganItemState extends State<SloganItem> {
  Slogan get slogan => widget.item;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    bool marked = Hive.box('slogan_mark').get(slogan.id) ?? false;

    var textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () async {
        setState(() {
          selected = !selected;
        });
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 40, top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*   Row(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          AnimatedContainer(
                            // height: selected ? 200 : 40,
                            duration: Duration(milliseconds: 250),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: 36,
                                  maxHeight: selected ? double.infinity : 36.0),
                              child:  */
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 36,
                  ),
                  child: Text(
                    selected ? slogan.text : slogan.text.replaceAll('\n', ''),
                    maxLines: selected ? 999 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                /*  ),
                          ), */
                /*       ],
                      ),
                    ),
                  ],
                ), */
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    for (var tag in slogan.tags)
                      Text(
                        tag,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
                children: /* Platform.isAndroid
                  ?  */
                    <Widget>[
                  /*   PopupMenuButton( */
                  /*          icon: Icon(
                          Icons.more_vert,
                          semanticLabel: 'Menü anzeigen',
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text(
                                marked ? 'Markierung entfernen' : 'Markieren'),
                            value: 'mark',
                          ),
                          PopupMenuItem(
                            child: Text('Teilen...'),
                            value: 'share',
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'mark':
                              setState(() {
                                Hive.box('slogan_mark').put(slogan.id, !marked);
                              });
                              break;
                            case 'share':
                              ShareUtil.shareSlogan(slogan);
                              break;
                          }
                        },
                      ), */
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (marked) {
                          Hive.box('slogan_mark').delete(slogan.id);
                        } else {
                          Hive.box('slogan_mark').put(slogan.id, !marked);
                        }
                      });
                      widget.setParentState(() {});
                    },
                    icon: Icon(
                      marked ? MdiIcons.star : MdiIcons.starOutline,
                      color: marked ? Theme.of(context).accentColor : null,
                      semanticLabel: 'Markierter Artikel',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ShareUtil.shareSlogan(slogan);
                    },
                    icon: Icon(Platform.isAndroid? MdiIcons.shareVariant : CupertinoIcons.share,
                      semanticLabel: 'Artikel teilen',
                    ),
                  ),
                ]
                /*  :
                  //iOS adaption (action sheet)
                  <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: Text(marked
                                          ? 'Markierung entfernen'
                                          : 'Markieren'),
                                      onPressed: () {
                                        setState(() {
                                          Hive.box('slogan_mark')
                                              .put(slogan.id, !marked);
                                        });
                                        Navigator.pop(context, 'Mark');
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: const Text('Teilen...'),
                                      onPressed: () {
                                        ShareUtil.shareSlogan(slogan);
                                        Navigator.pop(context, 'Share');
                                      },
                                    ),
                                  ],
                                  //cancel button
                                  cancelButton: CupertinoActionSheetAction(
                                    child: const Text('Abbrechen'),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                  ),
                                );
                              });
                        },
                        child: Icon(CupertinoIcons.ellipsis,
                            color: Theme.of(context).hintColor),
                      ),
                      if (marked)
                        Icon(
                          MdiIcons.bookmark,
                          semanticLabel: 'Markierter Artikel',
                          color: Theme.of(context).accentColor,
                        ),
                    ], */
                ),
          ),
        ],
      ),
    );
  }
}
