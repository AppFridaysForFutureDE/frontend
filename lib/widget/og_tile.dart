import 'package:app/model/strike.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
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
  // Image ogImage;

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
    // TODO: Remove
    og.imageLink =
        'https://www.zooroyal.de/magazin/wp-content/uploads/2017/11/Kakadu-760x560.jpg';
    // 'https://www.codemate.com/wp-content/uploads/2017/09/flutter-logo.png');
    og.infoTitle = 'So bereiten wir uns auf dem Großstreik in München vor';
    og.infoText =
        'Sobald das Datum des Streiks steht, geht die Planung los: In einer ersten Telefonkonferenz, kurz TK, wurden sowohl 14 Uhr als Uhrzeit und Theresienwiese als Ort, wie auch die Aktionsform festgelegt. Außerdem wurden erste Ideen und Pläne für die Arbeitsweise und vorläufige Zeitpläne erstellt. Kurz nach der zweiten Telefonkonferenz stand als Arbeitsweise das Arbeiten in themenspezifischen Kleingruppen fest. So gibt es unter anderem Gruppen für Presse, Programm und Logistik. Ergebnisse der Arbeit in diesen Untergruppen, kurz UGs, werden in wöchentlichen Plena besprochen und abgesegnet. Außerdem hat jede UG mindestens einen Hutmenschen, der*die sich darum kümmert, dass die UG mit der Arbeit vorankommt, TKs stattfinden und als Ansprechpartner*in zur Verfügung steht.';

    final ogImage = Image.network(og.imageLink);

    return ExpansionTile(
      initiallyExpanded: true,
      title: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.og.name,
              semanticsLabel: widget.og.name,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
            ),
          ],
        ),
      ),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO: Display dates in title of ExpansionTile
              Row(
                children: [
                  Text(
                    'Nächste Demo: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Keine Informationen')
                ],
              ),
              Row(
                children: [
                  Text(
                    'Nächstes Plenum: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Keine Informationen')
                ],
              ),
              // TODO: move social btns
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: SocialButtons(widget.og, true),
              // ),
              // TODO: display first strike
              // for (var strike in strikes)
              //   ListTile(
              //       title: Text(strike.name),
              //       subtitle: Semantics(
              //         child: Text(strike.location +
              //             ' • ' +
              //             DateFormat('dd.MM.yyyy, HH:mm')
              //                 .format(strike.dateTime) +
              //             (strike.additionalInfo.isEmpty
              //                 ? ''
              //                 : ' • ' + strike.additionalInfo)),
              //         label: strike.location +
              //             ' am ' +
              //             DateFormat('dd.MM.yyyy, HH:mm')
              //                 .format(strike.dateTime) +
              //             (strike.additionalInfo.isEmpty
              //                 ? ''
              //                 : ' Weitere Infos: ' + strike.additionalInfo),
              //       ),
              //       trailing: strike.eventLink.isEmpty
              //           ? null
              //           : IconButton(
              //               icon: Icon(
              //                 MdiIcons.openInNew,
              //                 semanticLabel: 'Anzeigen',
              //               ),
              //               onPressed: () {
              //                 _launchURL(strike.eventLink);
              //               }))
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Text(og.infoTitle, style: TextStyle(fontSize: 20)),
              ),

              DropCapText(
                og.infoText,
                dropCap: DropCap(
                    // TODO: fix image size
                    width: ogImage.width != null ? ogImage.width : 100,
                    height: ogImage.height != null ? ogImage.height : 100,
                    child: ogImage),
              ),
            ],
          ),
        )
      ],
    );
  }
}
