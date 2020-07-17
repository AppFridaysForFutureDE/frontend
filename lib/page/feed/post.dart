import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/util/share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class PostPage extends StatefulWidget {
  final Post post;

  /*
   * Indicates if the Widget displays a Post or a Page from the Ghost CMS
   * in a Page there will be not a title Bar and a Image 
   */
  final bool isPost;
  final String name;

  PostPage(this.post, {this.isPost = true, this.name});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Post get post => widget.post;
  bool get isPost => widget.isPost;
  String html;

  @override
  void initState() {
    super.initState();

    _loadPost();
  }

  _loadPost() async {
    if (post.id != null) {
      try {
        Post p = await api.getPostById(post.id);
        if (mounted) {
          setState(() {
            html = p.html;
          });
          Hive.box('post_read').put(post.id, true);
        }
      } catch (e) {
        if (mounted)
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                  'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
      }
    } else if (post.slug != null) {
      if (!isPost) {
        try {
          Post p = await api.getPageBySlug(post.slug);
          if (mounted)
            setState(() {
              html = p.html;
            });
        } catch (e) {
          if (mounted)
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                    'Der Inhalt konnte nicht geladen werden, bitte prüfe deine Internetverbindung.')));
        }
      }
    }
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool marked =
        post.id == null ? false : Hive.box('post_mark').get(post.id) ?? false;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          isPost ? post.tags.first.name : widget.name,
        ),
        actions: <Widget>[
          if (isPost)
            IconButton(
              icon: Icon(marked ? MdiIcons.bookmark : MdiIcons.bookmarkOutline, semanticLabel: marked ? 'Markiert' : 'Nicht markiert'),
              color: marked ? Theme.of(context).accentColor : null,
              onPressed: () {
                setState(() {
                  Hive.box('post_mark').put(post.id, !marked);
                });
              },
            ),
          if (isPost)
            IconButton(
              icon: Platform.isIOS ? Icon(CupertinoIcons.share) : Icon(Icons.share),
              tooltip: 'Artikel teilen',
              onPressed: () {
                ShareUtil.sharePost(post);
              },
            ),
        ],
      ),
      body: Scrollbar(
        child: ListView(
          children: <Widget>[
            if (post.featureImage != null)
              Image.network(
                post.featureImage,
              ),
            if (html == null) LinearProgressIndicator(),
            if (html != null) ...[
              if (isPost)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post.tags
                            .fold('', (a, b) => '$a • ${b.name.toUpperCase()}')
                            .substring(3),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        post.title,
                        style: TextStyle(
                          fontFamily: 'Merriweather',
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 32,
                        ),
                      ),
                      if (post.customExcerpt != null) ...[
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          post.customExcerpt,
                          style: TextStyle(fontSize: 15, height: 1.5, letterSpacing: 0.4),
                        ),
                      ],
                      Divider(),
                    ],
                  ),
                ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Html(
                  data: html,
                  defaultTextStyle: TextStyle(fontSize: 15, height: 1.3, letterSpacing: 0.4),
                  onLinkTap: (link) async {
                    if (await canLaunch(link)) launch(link);
                  },
                ),
              ),
              if (isPost)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: IconButton(
                      icon: Platform.isIOS?(
                          Icon(CupertinoIcons.share))
                    : Icon(Icons.share),
                    tooltip: 'Artikel teilen',
                    onPressed: () {
                      ShareUtil.sharePost(post);
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
