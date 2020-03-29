import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/util/share.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPage extends StatefulWidget {
  final Post post;

  /**
   * Indicates if the Widget displays a Post or a Page from the Ghost CMS
   * in a Page there will be not a title Bar and a Image 
   */
  bool isPost = true;
  PostPage(this.post);
  //the Contructor for a PostPage for a about Page
  PostPage.aboutPage(this.post, this.isPost);
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

    if (post.id != null)
      api.getPostById(post.id).then((p) {
        if (mounted)
          setState(() {
            html = p.html;
          });

        Hive.box('post_read').put(post.id, true);
      });
    else if (post.slug != null) {
      Future<Post> postF;
      if(this.isPost){
        postF = api.getPostBySlug(post.slug);
      }else{
        postF = api.getPageBySlug(post.slug);
      }
      
        postF.then((p) {
          if (mounted)
            setState(() {
              html = p.html;
            });

          //Hive.box('post_read').put(post.id, true);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool marked =
        post.id == null ? false : Hive.box('post_mark').get(post.id) ?? false;

    return Scaffold(
      body: Scrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            if (isPost)
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
                        child:
                            isPost //checks if the Title bar schould be Shown
                                ? Material(
                                    color: Colors.black.withOpacity(0.4),
                                    child: AppBar(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      title: post.title != null
                                          ? Text(post.title)
                                          : Text(""),
                                      actions: <Widget>[
                                        IconButton(
                                          icon: Icon(marked
                                              ? MdiIcons.bookmark
                                              : MdiIcons.bookmarkOutline),
                                          color: marked
                                              ? Theme.of(context).accentColor
                                              : null,
                                          onPressed: () {
                                            setState(() {
                                              Hive.box('post_mark')
                                                  .put(post.id, !marked);
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: () {
                                            ShareUtil.sharePost(post);
                                          },
                                        ),
                                      ],
                                    ))
                                : Container(),
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
