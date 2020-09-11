import 'package:app/app.dart';
import 'package:app/widget/title.dart';

class DemoFilterPage extends StatefulWidget {
  final FilterState state;
  final Set allTags;

  DemoFilterPage(this.state, this.allTags);

  @override
  _DemoFilterPageState createState() => _DemoFilterPageState();
}

class _DemoFilterPageState extends State<DemoFilterPage> {
  FilterState state = FilterState();
  @override
  void initState() {
    state.onlyShowMarked = widget.state.onlyShowMarked;
    state.shownTags = List.from(widget.state.shownTags);
    super.initState();
  }

//Used for screenreaders
  var onlyShowMarkedIsActive = 'Nur markierte Sprüche anzeigen. Nicht aktiv';

  void updateMarked() {
    if (state.onlyShowMarked) {
      onlyShowMarkedIsActive = 'Nur markierte Sprüche anzeigen. Aktiv';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(state);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Demospruch Filter'),
        ),
        body: ListView(
          children: <Widget>[
            TitleWidget('Markierung'),
            Semantics(
              child: SwitchListTile.adaptive(
                  value: state.onlyShowMarked,
                  title: Text('Nur markierte Sprüche anzeigen'),
                  onChanged: (val) {
                    setState(() {
                      state.onlyShowMarked = val;
                      updateMarked();
                    });
                    updateMarked();
                  }),
              label: onlyShowMarkedIsActive,
            ),
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
            ),
            // TODO: Maybe add reset button? 
            // Currently it is too big, maybe add a save button next to it?
            // SizedBox(height: 50),
            // Center(
            //   child: FlatButton(
            //     color: Theme.of(context).primaryColor,
            //     child: Text('Alle Filter zurücksetzen'),
            //     onPressed: (){
            //       state.onlyShowMarked = false;
            //       state.shownTags = []; // List.from(widget.allTags);
            //       Navigator.of(context).pop(state);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String tag) {
    bool active = state.shownTags.contains(tag);
    var isActive = ''; //used for screenreaders
    if (active) {
      isActive = 'Aktiv';
    } else {
      isActive = 'Nicht aktiv';
    }
    return InkWell(
      onTap: () {
        if (active) {
          state.shownTags.remove(tag);
          isActive = 'Nicht aktiv';
        } else {
          state.shownTags.add(tag);
          isActive = 'Aktiv';
        }
        setState(() {});
      },
      child: Chip(
        backgroundColor: active ? Theme.of(context).primaryColor : null,
        label: Text(
          tag,
          semanticsLabel: tag + '. ' + isActive,
        ),
      ),
    );
  }
}

class FilterState {
  bool onlyShowMarked = false;

  List<String> shownTags = [];

  bool get filterActive => onlyShowMarked || shownTags.isNotEmpty;
}
