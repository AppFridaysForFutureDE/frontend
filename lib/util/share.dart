import 'package:share/share.dart';

import 'package:app/model/post.dart';

class ShareUtil {
  static sharePost(Post post) {
    // TODO Teilen-Text ändern
    Share.share(
        'Lies "${post.title}" jetzt in der neuen App For Future! https://app.fffutu.re/p/${post.id}');
  }
}
