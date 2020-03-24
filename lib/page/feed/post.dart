import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPage extends StatefulWidget {
  final Post post;
  PostPage(this.post);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Post get post => widget.post;

  String html;

  @override
  void initState() {
    super.initState();

    api.getPostById(post.id).then((p) {
      if (mounted)
        setState(() {
          html = p.html;
        });

      Hive.box('post_read').put(post.id, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: SizedBox(),
              flexibleSpace: SafeArea(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: post.featureImage == null
                          ? Container(
                              color: Colors.blue,
                            )
                          : Image.network(
                              post.featureImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: Material(
                          color: Colors.black.withOpacity(0.4),
                          child: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            title: Text(post.title),
                            actions: <Widget>[
                              IconButton(
                                icon: Icon(Icons.favorite),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.share),
                                onPressed: () {},
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              expandedHeight: 200,
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  html == null
                      ? LinearProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Html(
                            data: html,
                            onLinkTap: (link) async {
                              if (await canLaunch(link)) launch(link);
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
