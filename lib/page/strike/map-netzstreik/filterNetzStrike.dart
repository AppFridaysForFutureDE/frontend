import 'package:app/widget/title.dart';

import '../../../app.dart';

class FilterNetzStrikePage extends StatefulWidget {
  @override
  _FilterNetzStrikePageState createState() => _FilterNetzStrikePageState();
  final FilterStateNetz state;
  FilterNetzStrikePage(this.state);
}

class _FilterNetzStrikePageState extends State<FilterNetzStrikePage> {
  FilterStateNetz state = FilterStateNetz();
  void initState() {
    super.initState();
    state.onlyShowImage = widget.state.onlyShowImage;
    state.onlyShowFeatured = widget.state.onlyShowFeatured;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: ListView(
        children: <Widget>[
          TitleWidget('Bilder'),
          SwitchListTile.adaptive(
              value: state.onlyShowImage,
              title: Text('Nur Einträge mit Bildern zeigen'),
              onChanged: (val) {
                setState(() {
                  state.onlyShowImage = val;
                });
              }),
          TitleWidget('Featured'),
          SwitchListTile.adaptive(
              value: state.onlyShowFeatured,
              title: Text('Nur Featured Einträge zeigen'),
              onChanged: (val) {
                setState(() {
                  state.onlyShowFeatured = val;
                });
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.of(context).pop(state);
        },
      ),
    );
  }
}

class FilterStateNetz {
  bool onlyShowImage = false;

  bool onlyShowFeatured = false;

  bool get filterActive => onlyShowFeatured || onlyShowImage;
}
