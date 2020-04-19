import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:app/app.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class FutureStoryPage extends StatelessWidget {
  _shareImage() async {
    if (await Permission.storage.request().isGranted) {
      var res = await http.get('https://app.fffutu.re/img/instagram_story.jpg');
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
        title: Text('Zukunfts-Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: AutoSizeText(
                'Die Zukunft, ein Traum den jede*r hat. Doch die Klimakrise bringt ebenjene in Gefahr... Die Zeit etwas zu ändern ist jetzt!' +
                    '\n' +
                    'Fülle die Vorlage für die Story aus und tagge drei deiner Freunde. Hilf uns dabei, awareness zu spreaden und die Zukunft zu retten!',
                maxLines: 6,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Image.network(
                  'https://app.fffutu.re/img/instagram_instructions.jpg',
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: _shareImage,
                      child: Text('Vorlage herunterladen')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
