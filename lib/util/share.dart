import 'package:share/share.dart';

import 'package:app/model/post.dart';

class ShareUtil {
  static sharePost(Post post) {
    // TODO Teilen-Text ändern
    // TODO Eventuell esys_flutter_share anstatt share verwenden (und dann share aus den dependencies entferenen)
    Share.share('Lies "${post.title}" jetzt in der neuen FFFApp! <link>');
  }
}
