import 'package:app/app.dart';
import 'package:app/widget/title.dart';

class SloganPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spruch'),
      ),
      body: ListView(
        children: <Widget>[
          Semantics(
            child: TitleWidget('Social Media Kanäle'),
            label: 'Social Media Kanäle. Bereichsüberschrift',
          ),
        ],
      ),
    );
  }
}
