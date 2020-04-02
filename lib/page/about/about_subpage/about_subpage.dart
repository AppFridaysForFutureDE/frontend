/* import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';

/**
 * A Page that takes a SLUG to a Post and
 * then creates a title and Take for the Body the PostPage Widget
 */
class AboutSubpage extends StatefulWidget {
  final String slug;
  AboutSubpage(this.slug) {
    //super();
  }

  @override
  _AboutSubpageState createState() => _AboutSubpageState();
}

class _AboutSubpageState extends State<AboutSubpage> {
  String title = "";
  //Both the title and the Body are saved in the State in order to not triger a reload when Date ist loaded
  //later (for example the title)
  get slug => widget.slug;
  Widget body = null;
  @override
  initState() {
    _loadTitle();
    //creates a Post Page without a title Bar
    body = 
  }

  /**
   * Loads the Title from the Api and refreshs the Page
   */

  void _loadTitle() async {
    title = await (api.getPageTitleBySlug(slug));
    if (mounted) setState(() {});
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
 */