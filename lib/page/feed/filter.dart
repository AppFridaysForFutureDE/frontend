import 'package:app/app.dart';
import 'package:app/widget/title.dart';

class FilterPage extends StatefulWidget {
  final FilterState state;
  FilterPage(this.state);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  FilterState state = FilterState();
  @override
  void initState() {
    state.onlyShowMarked = widget.state.onlyShowMarked;
    state.onlyShowUnread = widget.state.onlyShowUnread;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: ListView(
        children: <Widget>[
          TitleWidget('Status'),
          SwitchListTile.adaptive(
              value: state.onlyShowUnread,
              title: Text('Nur ungelesene Artikel anzeigen'),
              onChanged: (val) {
                setState(() {
                  state.onlyShowUnread = val;
                });
              }),
          TitleWidget('Markierung'),
          SwitchListTile.adaptive(
              value: state.onlyShowMarked,
              title: Text('Nur markierte Artikel anzeigen'),
              onChanged: (val) {
                setState(() {
                  state.onlyShowMarked = val;
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

class FilterState {
  bool onlyShowMarked = false;

  bool onlyShowUnread = false;

  bool get filterActive => onlyShowMarked || onlyShowUnread;
}
