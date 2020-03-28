import 'package:app/app.dart';
class AboutSubpage extends  StatelessWidget {
  final Widget content;
  final String title;
  AboutSubpage( this.title,  this.content){
    //super();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: content,
    );
  }
}
