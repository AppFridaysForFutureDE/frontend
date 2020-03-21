import 'package:app/app.dart';
class ImpressumPage extends  StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Impressum'),
      ),
      body: Center(
        child: Text(
          'Hier kommt unser Impressum hin',
        ),
      ),
    );
  }
}
