import 'package:app/app.dart';
import 'package:app/widget/title.dart';

class FilterPage extends StatefulWidget {
  final FilterState state;
  final Set allTags;

  FilterPage(this.state, this.allTags);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  FilterState state = FilterState();
  @override
  void initState() {
    state.onlyShowMarked = widget.state.onlyShowMarked;
    state.onlyShowUnread = widget.state.onlyShowUnread;
    state.shownTags = List.from(widget.state.shownTags);
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
          TitleWidget('Kategorien'),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Wrap(
              spacing: 8,
              children: <Widget>[
                for (String tag in widget.allTags) _buildTag(tag),
              ],
            ),
          )
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

  Widget _buildTag(String tag) {
    bool active = state.shownTags.contains(tag);
    return InkWell(
      onTap: () {
        if (active) {
          state.shownTags.remove(tag);
        } else {
          state.shownTags.add(tag);
        }
        setState(() {});
      },
      child: Chip(
        backgroundColor: active ? Theme.of(context).primaryColor : null,
        label: Text(
          tag,
          style: TextStyle(
              //  color: Colors.black,
              ),
        ),
      ),
    );
  }
}

class FilterState {
  bool onlyShowMarked = false;

  bool onlyShowUnread = false;

  List<String> shownTags = [];

  bool get filterActive =>
      onlyShowMarked || onlyShowUnread || shownTags.isNotEmpty;
}
