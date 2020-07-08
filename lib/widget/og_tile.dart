import 'package:app/model/strike.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/app.dart';

/*
A Tile wich displays a OG in  a Scroll View and is extandable
 */
class OgTile extends StatefulWidget {
  final OG og;
  /*
  The Contructor takes an og Object
   */
  OgTile(this.og);

  @override
  _OgTileState createState() => _OgTileState();
}

class _OgTileState extends State<OgTile> {
  OG get og => widget.og;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Strike> strikes;

  @override
  void initState() {
    super.initState();
    strikes = (Hive.box('strikes').get(og.ogId) ?? []).cast<Strike>();
    _loadData();
  }

  _loadData() async {
    try {
      strikes = await api.getStrikesByOG(og.ogId);
      if (mounted) setState(() {});
      Hive.box('strikes').put(og.ogId, strikes);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        widget.og.name +
            ' • ' + /* BundeslandUtil.render( */ widget.og.bundesland /* ) */,
        semanticsLabel: widget.og.name + ' in ' +widget.og.bundesland,
        style: Theme.of(context).textTheme.title,
      ),
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SocialButtons(widget.og, true),
              ),
              for (var strike in strikes)
                ListTile(
                    title: Text(strike.name),
                    subtitle: Semantics(
                      child: Text(strike.location +
                        ' • ' +
                        DateFormat('dd.MM.yyyy, HH:mm')
                            .format(strike.dateTime) +
                        (strike.additionalInfo.isEmpty
                            ? ''
                            : ' • ' + strike.additionalInfo)),
                      label: strike.location +
                        ' am ' +
                        DateFormat('dd.MM.yyyy, HH:mm')
                            .format(strike.dateTime) +
                        (strike.additionalInfo.isEmpty
                            ? ''
                            : ' Weitere Infos: ' + strike.additionalInfo),
                    ),
                    trailing: strike.eventLink.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              MdiIcons.openInNew,
                              semanticLabel: 'Streik anzeigen',
                            ),
                            onPressed: () {
                              _launchURL(strike.eventLink);
                            }))
            ],
          ),
        )
      ],
    );
  }
}
