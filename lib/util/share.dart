import 'package:app/model/slogan.dart';
import 'package:share/share.dart';

import 'package:app/model/post.dart';

class ShareUtil {
  static sharePost(Post post) {
    // TODO Teilen-Text ändern
    Share.share(
        'Lies "${post.title}" jetzt in der neuen App For Future! https://app.fffutu.re/p/${post.id}');
  }

  static shareSlogan(Slogan slogan) {
    Share.share(
        'Ich kenne einen Demospruch und der geht so: "${slogan.text}" Dies und viel mehr gibt\'s in der AppForFuture: https://app.fffutu.re/download/');
  }
}
