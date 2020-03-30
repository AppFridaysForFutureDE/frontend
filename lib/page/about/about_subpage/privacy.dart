import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';

class PrivacyPage extends StatefulWidget {
  bool isPopup = true;
  Function setStateDelegate = null;
  PrivacyPage.onStart(this.setStateDelegate);
  PrivacyPage.subPage(){
    isPopup = false;
  }
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  get isPopup => widget.isPopup;
  get setStateDelegate => widget.setStateDelegate;
  Widget body = Container();
  String slug = 'datenschutz';
  String title = '';
  void _loadTitle() async {
    title = await (api.getPageTitleBySlug(slug));
    if (mounted) setState(() {});
  }
  initState(){
    _loadTitle();
    body = PostPage.aboutPage(
      Post.slug(slug),
      false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => !isPopup ,
      child: Scaffold(
          appBar:isPopup ? AppBar(
            leading: Container(),
            actions:  <Widget>[
              FlatButton(
                  child: Text(
                    "Akzeptieren ✅",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.title.fontSize,
                      color: Colors.white,
                    ),
                  ),
                onPressed: () {
                  Hive.box("acceptet").put("isAcceptet",true);
                  setStateDelegate(() {});
                  //Navigator.pop(context);
                },
              )
            ],
            title: Text('$title'),
          )
          :AppBar(title: Text('$title'),),
          body: body),
    );
  }
}
