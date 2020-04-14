import 'dart:io';
import 'dart:typed_data';
import 'package:app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class FutureStoryPage extends StatelessWidget {
  
  _shareImage() async {
    Uri url = Uri.parse('https://app.fffutu.re/instagram_story.jpg');
    var request = await HttpClient().getUrl(url);
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file('Zukunfts Story', 'future_story.jpg', bytes, 'image/jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
