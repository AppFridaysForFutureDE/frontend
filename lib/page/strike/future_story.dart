import 'package:flutter/foundation.dart';
import 'package:app/app.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class FutureStoryPage extends StatelessWidget {
  _shareImage() async {
    if (await Permission.storage.request().isGranted) {
      var res = await http.get('https://app.fffutu.re/instagram_story.jpg');
      await ImageGallerySaver.saveImage(res.bodyBytes);
      _showSnack('Die Vorlage ist jetzt in deiner Galerie gespeichert.');
    } else {
      _showSnack('Keine Berechtigung');
    }
  }

  _showSnack(text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Zukunfts Story'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Text('Nach Corona willst du in eine lebenswerte Zukunft blicken? ' +
                'Eine Zukunft ohne weitere Pandemien, extreme Wettervorkommen oder andere Folgen des Klimawandels?'),
            Text(
                "Dann mach mit und fordere deine Klimaschutzmaßnahmen von der Politik!"),
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Image(
                  image: NetworkImage(
                      'https://app.fffutu.re/instagram_instructions.jpg'),
                ),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _shareImage,
                    child: Text('Vorlage herunterladen')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
