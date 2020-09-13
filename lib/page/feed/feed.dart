import 'dart:io';

import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';
import 'package:app/service/api.dart';
import 'package:app/util/share.dart';
import 'package:app/util/time_ago.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                    return FeedItem(
                      highlightedArticle,
                      highlighted: true,
                    );
                  }
                  return FeedItem(
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

class FeedItem extends StatefulWidget {
  final Post item;
  final bool highlighted;
  final bool showExcerpt;

  final bool isImageLeftAligned;

  FeedItem(this.item,
      {this.highlighted = false,
      this.showExcerpt = true,
      this.isImageLeftAligned = true});

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  Post get post => widget.item;
  bool get highlighted => widget.highlighted;
  bool get isImageLeftAligned => widget.isImageLeftAligned;

  Widget _buildCategories(TextTheme textTheme) => Text(
        post.tags
            .fold('',
                (previousValue, element) => '$previousValue / ${element.name}')
            .substring(3),
        style: textTheme.overline,
      );

  @override
  Widget build(BuildContext context) {
    bool read = Hive.box('post_read').get(post.id) ?? false;
    bool marked = Hive.box('post_mark').get(post.id) ?? false;

    var textTheme = Theme.of(context).textTheme;

    if (read) {
      textTheme = textTheme.apply(
        bodyColor: Theme.of(context).hintColor,
      );
    }

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostPage(post),
          ),
        );
        setState(() {});
      },
      child: Column(
        children: [
          if (highlighted)
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                CachedNetworkImage(
                  imageUrl: post.featureImage ?? '',
                  width: double.infinity,
                ),
                Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: _buildCategories(textTheme),
                  ),
                ),
              ],
            ),
          Stack(
            alignment: highlighted ? Alignment.bottomLeft : Alignment.topRight,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        if (post.featureImage != null &&
                            !highlighted &&
                            isImageLeftAligned) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: CachedNetworkImage(
                              imageUrl: post.featureImage ?? '',
                              width: 80,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (!highlighted) ...[
                                _buildCategories(textTheme),
                                SizedBox(
                                  height: 2,
                                ),
                              ],
                              ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 32),
                                child: Text(
                                  post.title,
                                  style: textTheme.headline5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (post.featureImage != null &&
                            !highlighted &&
                            !isImageLeftAligned) ...[
                          SizedBox(
                            width: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: CachedNetworkImage(
                              imageUrl: post.featureImage ?? '',
                              width: 80,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (widget.showExcerpt && post.customExcerpt != null)
                      Text(
                        post.customExcerpt,
                        style: textTheme.bodyText2,
                      ),
                    if (highlighted)
                      SizedBox(
                        height: 32,
                      ),
                    /*        Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children: <Widget>[
                              for (var tag in post.tags)
                                Chip(
                                  label: Text(
                                    tag.name,
                                    style: textTheme.body1,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          'vor ' + TimeAgoUtil.render(post.publishedAt),
                          style: textTheme.body1,
                        ),
                      ],
                    ), */
                  ],
                ),
              ),
              /*   Align(
                alignment:
                    highlighted ? Alignment.bottomLeft : Alignment.topRight,
                child: */
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (highlighted)
                    IconButton(
                      icon: Icon(
                        MdiIcons.shareVariant,
                        semanticLabel: 'Artikel teilen',
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        ShareUtil.sharePost(post);
                      },
                    ),
                  IconButton(
                    icon: Icon(
                      marked ? MdiIcons.bookmark : MdiIcons.bookmarkOutline,
                      color:
                          marked ? Theme.of(context).accentColor : Colors.grey,
                      semanticLabel: 'Artikel markieren',
                    ),
                    onPressed: () {
                      setState(() {
                        Hive.box('post_mark').put(post.id, !marked);
                      });
                    },
                  ),
                  if (!isImageLeftAligned)
                    SizedBox(
                      width: 90,
                    ),
                ],
              ),
              /*  ), */
/*               Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: Platform.isAndroid
                      ? <Widget>[
                          if (marked)
                            Icon(
                              MdiIcons.bookmark,
                              color: Theme.of(context).accentColor,
                              semanticLabel: 'Markierter Artikel',
                            ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              semanticLabel: 'Menü anzeigen',
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(marked
                                    ? 'Markierung entfernen'
                                    : 'Markieren'),
                                value: 'mark',
                              ),
                              PopupMenuItem(
                                child: Text('Teilen...'),
                                value: 'share',
                              ),
                              if (read)
                                PopupMenuItem(
                                  child: Text('Als ungelesen kennzeichnen'),
                                  value: 'unread',
                                ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 'mark':
                                  setState(() {
                                    Hive.box('post_mark').put(post.id, !marked);
                                  });
                                  break;
                                case 'share':
                                  ShareUtil.sharePost(post);
                                  break;
                                case 'unread':
                                  setState(() {
                                    Hive.box('post_read').put(post.id, false);
                                  });
                                  break;
                              }
                            },
                          ),
                        ]
                      :
                      //iOS adaption (action sheet)
                      <Widget>[
                          if (marked)
                            Icon(
                              MdiIcons.bookmark,
                              semanticLabel: 'Markierter Artikel',
                              color: Theme.of(context).accentColor,
                            ),
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
                                              Hive.box('post_mark')
                                                  .put(post.id, !marked);
                                            });
                                            Navigator.pop(context, 'Mark');
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: const Text('Teilen...'),
                                          onPressed: () {
                                            ShareUtil.sharePost(post);
                                            Navigator.pop(context, 'Share');
                                          },
                                        ),
                                        if (read)
                                          CupertinoActionSheetAction(
                                            child: const Text(
                                                'Als ungelesen kennzeichnen'),
                                            onPressed: () {
                                              setState(() {
                                                Hive.box('post_read')
                                                    .put(post.id, false);
                                              });
                                              Navigator.pop(context, 'Read');
                                            },
                                          )
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
                        ],
                ),
              ), */
            ],
          ),
        ],
      ),
    );
  }
}
