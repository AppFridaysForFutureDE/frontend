import 'package:app/model/slogan.dart';
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

  static shareSlogan(Slogan slogan) {
    Share.share(
        'Ich kenne einen Demospruch und der geht so: "${slogan.text}" Dies und viel mehr gibt\'s in der AppForFuture: https://app.fffutu.re/download/');
  }

  static shareStrike(Strike strike){
    Share.share(
      'Hey, mach jetzt mit beim Streik in ${strike.location} am ${DateFormat('dd.MM.yyyy, HH:mm')
                            .format(strike.dateTime)}! ' + (strike.additionalInfo.isEmpty
                            ? ''
                            : '(${strike.additionalInfo})')
      );
  }

  static sharePlenum(Strike strike){
    Share.share(
      'Hey, komm zum nächsten Plenum am ${DateFormat('dd.MM.yyyy, HH:mm') 
                            .format(strike.dateTime)} ' 
                            + 'in ${strike.location}! '
                            + (strike.additionalInfo.isEmpty
                            ? ''
                            : '(${strike.additionalInfo})')
      );
  }
}
