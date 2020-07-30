import 'package:share/share.dart';
import 'package:app/model/strike.dart';
import 'package:app/model/post.dart';
import 'package:intl/intl.dart';

class ShareUtil {
  static sharePost(Post post) {
    // TODO Teilen-Text ändern
    Share.share(
        'Lies "${post.title}" jetzt in der neuen App For Future! https://app.fffutu.re/p/${post.id}');
  }

  static shareStrike(Strike strike){
    Share.share(
      'Hey, mach jetzt mit beim Streik in ${strike.location} am ${DateFormat('dd.MM.yyyy, HH:mm')
                            .format(strike.dateTime)}! ' + (strike.additionalInfo.isEmpty
                            ? ''
                            : '(${strike.additionalInfo})')
      );
  }
}
