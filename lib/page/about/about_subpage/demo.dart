import 'package:app/app.dart';
class DemoPage extends  StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demosprüche'),
      ),
      body: Center(
        child: Text(
          'Hier kommen Tolle Demo sprüche hin',
        ),
      ),
    );
  }
}
