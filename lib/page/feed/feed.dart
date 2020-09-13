import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/service/api.dart';
import 'package:app/widget/feed_item.dart';
import 'package:flutter/cupertino.dart';

import 'filter.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Future _loadData() async {
    try {
      posts = await api.getPosts();

      if (mounted) setState(() {});
    } catch (e) {
      if (mounted)
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
    }
  }

  List<Post> posts;

  bool searchActive = false;
  String searchText = '';

  var filterState = FilterState();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.white,
          // centerTitle: !Platform.isIOS,
          title: searchActive
              ? TextField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: false,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Suchen',
                      hintStyle: TextStyle(color: Colors.white)),
                  onChanged: (s) {
                    setState(() {
                      searchText = s;
                    });
                  },
                )
              : Text('Newsfeed', semanticsLabel: 'Neuigkeitenfeed'),
          bottom: searchActive
              ? null
              : TabBar(
                  tabs: [
                    for (var cat in feedCategories)
                      Tab(
                        text: cat,
                      ),
                  ],
                  indicatorWeight: 4,
                ),
          actions: <Widget>[
            if (posts != null)
              if (!searchActive)
                IconButton(
                  icon: Icon(MdiIcons.filter),
                  tooltip: 'Filter Einstellungen',
                  onPressed: () async {
                    var newFilterState = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FilterPage(
                          filterState,
                          posts.fold<Set>(
                              Set(),
                              (a, b) => a
                                ..addAll(b.tags
                                    .map<String>((t) => t.name)
                                    .toList())),
                        ),
                      ),
                    );

                    if (newFilterState != null)
                      setState(() {
                        filterState = newFilterState;
                      });
                  },
                ),
            if (posts != null)
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
        ),
        body: posts == null
            ? LinearProgressIndicator()
            : Column(
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
                          : TabBarView(
                              children: [
                                for (var cat in feedCategories)
                                  _buildListView(category: cat),
                              ],
                            )),
                ],
              ),
      ),
    );
  }

  Widget _buildListView({String category, String text}) {
    List<Post> shownPosts = List.from(posts);

    if (filterState.filterActive) {
      if (filterState.onlyShowMarked) {
        var markBox = Hive.box('post_mark');
        shownPosts =
            shownPosts.where((p) => (markBox.get(p.id) ?? false)).toList();
      }
      if (filterState.onlyShowUnread) {
        var readBox = Hive.box('post_read');
        shownPosts =
            shownPosts.where((p) => !(readBox.get(p.id) ?? false)).toList();
      }
      if (filterState.shownTags.isNotEmpty) {
        shownPosts = shownPosts
            .where((p) =>
                p.tags.map((t) => t.name).firstWhere(
                    (s) => filterState.shownTags.contains(s),
                    orElse: () => null) !=
                null)
            .toList();
      }
    }

    Post highlightedArticle;

    if (category != null) {
      shownPosts = shownPosts
          .where((p) => p.tags.indexWhere((t) => t.name == category) != -1)
          .toList();

      highlightedArticle = shownPosts.firstWhere(
          (element) =>
              element.tagsInternal.map((t) => t.name).contains('Highlight'),
          orElse: () => null);

      if (highlightedArticle != null) {
        shownPosts.remove(highlightedArticle);
        shownPosts.insert(0, null);
      }
    } else {
      shownPosts = shownPosts
          .where((p) => ((p.title ?? '') +
                  ' ' +
                  (p.customExcerpt ?? '') +
                  p.tags.map((t) => t.name).toString() +
                  (p.primaryAuthor?.name ?? ''))
              .toLowerCase()
              .contains(text))
          .toList();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: shownPosts.isEmpty
          ? Center(
              child: Text('Keine Ergebnisse'),
            )
          : Scrollbar(
              child: ListView.separated(
                itemCount: shownPosts.length,
                itemBuilder: (context, index) {
                  final post = shownPosts[index];

                  if (post == null) {
                    return FeedItemWidget(
                      highlightedArticle,
                      highlighted: true,
                    );
                  }
                  return FeedItemWidget(
                    post,
                    showExcerpt: true,
                    isImageLeftAligned: index % 2 == 0,
                  );
                },
                separatorBuilder: (context, index) => Container(
                  height: 0.5,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
    );
  }
}
