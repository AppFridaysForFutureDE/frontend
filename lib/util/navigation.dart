import 'package:app/app.dart';
import 'package:app/page/feed/post.dart';
import 'package:app/page/strike/map-netzstreik/add-iframe-page.dart';

import 'package:url_launcher/url_launcher.dart';

class NavUtil {
  final BuildContext context;

  NavUtil(this.context);

  void openLink(String link, bool inApp, String inAppTitle) async {
    if (link.startsWith('https://app.fffutu.re/p/')) {
      final post = await api.getPostById(link.split('/').last, metadata: true);

      if (post == null) throw 'Post not found';

/*       if (post == null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Der Artikel konnte nicht gefunden werden.')));
      } else { */
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PostPage(post),
        ),
      );
      /*  } */
    } else {
      if (inApp) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddIFramePage(
                  url: link,
                  inAppTitle: inAppTitle ?? 'Aktion',
                )));
      } else {
        if (await canLaunch(link)) {
          await launch(link);
        } else {
          throw 'Could not launch $link';
        }
      }
    }
  }
}
