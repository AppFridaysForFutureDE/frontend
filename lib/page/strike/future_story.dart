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
        title: Text('Zukunfts Story'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Image.network(
                    'https://app.fffutu.re/img/instagram_instructions.jpg',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Text(
                      '''' Die Zukunft, ein Traum den jeder hat. Doch die Klimakrise bringt ebenjene in Gefahr.
Also: Let's save our future! Wir brauchen deine Hilfe. 
Du fragst dich wie du in Zeiten von Corona trotzdem noch solidarisch auf die Klimakrise hinweisen kannst? Folge einfach unserer kurzen Anleitung! 
Fülle die Vorlage aus. Tagge unsere Regierung, um ihr die Präsenz der Klimakrise wieder bewusst zu machen. Und zudem noch drei Medien Kanäle, sodass diese das Klima und seine Veränderungen in ihrer Berichterstattung involvieren. Zu guter Letzt, vergesse nicht 5 Freunde zu taggen um sie zum Mitmachen zu engagieren.''',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
              top: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/images/download.png',
                  width: 48,
                ),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _shareImage,
                    child: Text('Vorlage herunterladen')),
                Image.asset(
                  'assets/images/download.png',
                  width: 48,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
