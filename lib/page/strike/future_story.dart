import 'package:app/app.dart';

class FutureStoryPage extends StatelessWidget {
  static const url = 'https://app.fffutu.re/instagram_story.jpg';

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
                FlatButton(
                    // TODO: Style this button
                    onPressed: null, // TODO: Download or share image from url
                    child: Text('Vorlage herunterladen')
                    ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
