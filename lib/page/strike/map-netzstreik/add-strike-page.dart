import '../../../app.dart';

class AddStrikePage extends StatefulWidget {
  @override
  _AddStrikePageState createState() => _AddStrikePageState();
}

class _AddStrikePageState extends State<AddStrikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mitstreiken'),
      ),
      body: Text("Hier kommt was hin"),
    );
  }
}
