import 'package:app/app.dart';

class StrikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Netzstreik'),
      ),
      body: Center(
        child: Text(
          'Hier kommen Tolle Streiks hin',
        ),
      ),
    );
  }
}
