import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';

class PrivacyPage extends StatefulWidget {
  bool mustHave = true;
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
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
    return Scaffold(
        appBar: AppBar(
          title: Text('$title'),
        ),
        body: body);
  }
}
