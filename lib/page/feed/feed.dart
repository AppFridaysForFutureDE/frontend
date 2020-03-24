import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';
import 'package:app/util/share.dart';
import 'package:app/util/time_ago.dart';

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
    posts = await api.getPosts();
    if (mounted) setState(() {});
  }

  List<Post> posts;

  final List<String> categories = ['Wissenschaft', 'Intern', 'Politik'];

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
          title: searchActive
              ? TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  onChanged: (s) {
                    setState(() {
                      searchText = s;
                    });
                  },
                )
              : Text('Newsfeed'),
          bottom: searchActive
              ? null
              : TabBar(
                  tabs: [
                    for (var cat in categories)
                      Tab(
                        text: cat,
                      ),
                  ],
                ),
          actions: <Widget>[
            if (!searchActive)
              IconButton(
                icon: Icon(MdiIcons.filterVariant),
                onPressed: () async {
                  var newFilterState = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FilterPage(filterState),
                    ),
                  );

                  if (newFilterState != null)
                    setState(() {
                      filterState = newFilterState;
                    });
                },
              ),
            IconButton(
              icon: Icon(searchActive ? Icons.close : MdiIcons.magnify),
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
                      child: Text('Es sind Filter aktiv'),
                    ),
                  Expanded(
                      child: searchActive
                          ? _buildListView(text: searchText.toLowerCase())
                          : TabBarView(
                              children: [
                                for (var cat in categories)
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
    }

    if (category != null) {
      shownPosts = shownPosts
          .where((p) => p.tags.indexWhere((t) => t.name == category) != -1)
          .toList();
    } else {
      shownPosts = shownPosts
          .where((p) => (p.title +
                  p.customExcerpt +
                  p.tags.map((t) => t.name).toString() +
                  (p.primaryAuthor?.name ?? ''))
              .toLowerCase()
              .contains(text))
          .toList();
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.separated(
        itemCount: shownPosts.length,
        itemBuilder: (context, index) {
          return FeedItem(shownPosts[index]);
        },
        separatorBuilder: (context, index) => Container(
          height: 0.5,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }
}

class FeedItem extends StatefulWidget {
  final Post item;
  FeedItem(this.item);

  @override
  _FeedItemState createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  Post get post => widget.item;

  @override
  Widget build(BuildContext context) {
    bool read = Hive.box('post_read').get(post.id) ?? false;
    bool marked = Hive.box('post_mark').get(post.id) ?? false;

    var textTheme = Theme.of(context).textTheme;

    if (read) {
      textTheme = textTheme.apply(
        bodyColor: Colors.grey,
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
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (post.authors.isNotEmpty)
                      Text(
                        'Quelle/Autor',

                        //item.authors.first.name,,
                        style: textTheme.body1,
                      ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            post.title,
                            style: textTheme.subhead,
                          ),
                          if (post.customExcerpt != null)
                            Text(
                              post.customExcerpt,
                              style: textTheme.body1,
                            ),
                        ],
                      ),
                    ),
                    if (post.featureImage != null) ...[
                      SizedBox(
                        width: 16,
                      ),
                      Image.network(
                        post.featureImage ?? '',
                        width: 80,
                      ),
                    ]
                  ],
                ),
                Row(
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
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (marked)
                  Icon(
                    MdiIcons.bookmark,
                    color: Theme.of(context).accentColor,
                  ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child:
                          Text(marked ? 'Markierung entfernen' : 'Markieren'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
