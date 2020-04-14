import 'package:app/app.dart';

class ChallengePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<ChallengePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In Home Challenge'),
      ),
      body: Container(
        child: Text("hey"),
      ),
    );
  }
}
