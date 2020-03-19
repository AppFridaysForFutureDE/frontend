import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';
import 'package:app/util/time_ago.dart';

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

  _loadData() async {
    posts = await api.getPosts();
    if (mounted) setState(() {});
  }

  List<Post> posts;

  final List<String> categories = ['Wissenschaft', 'Intern', 'Politik'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Newsfeed'),
          bottom: TabBar(
            tabs: [
              for (var cat in categories)
                Tab(
                  text: cat,
                ),
            ],
          ),
        ),
        body: posts == null
            ? LinearProgressIndicator()
            : TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var cat in categories) _buildListView(cat),
                ],
              ),
      ),
    );
  }

  Widget _buildListView(String category) {
    var catPosts = posts
        .where((p) => p.tags.indexWhere((t) => t.name == category) != -1)
        .toList();

    return ListView.separated(
      itemCount: catPosts.length,
      itemBuilder: (context, index) {
        return _buildFeedItem(catPosts[index]);
      },
      separatorBuilder: (context, index) => Container(
        height: 0.5,
        color: Theme.of(context).hintColor,
      ),
    );
  }

  Widget _buildFeedItem(Post item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostPage(item),
          ),
        );
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
                    if (item.authors.isNotEmpty)
                      Text('Quelle/Autor'
                          //item.authors.first.name,

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
                            item.title,
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          if (item.customExcerpt != null)
                            Text(
                              item.customExcerpt,
                            ),
                        ],
                      ),
                    ),
                    if (item.featureImage != null) ...[
                      SizedBox(
                        width: 16,
                      ),
                      Image.network(
                        item.featureImage ?? '',
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
                          for (var tag in item.tags)
                            Chip(
                              label: Text(
                                tag.name,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text('vor ' + TimeAgoUtil.render(item.publishedAt)),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text('Mehr'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
