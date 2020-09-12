import 'package:app/model/strike.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app/app.dart';

/*
A Tile wich displays a OG in a Scroll View and is extandable
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

  // showOGDetails() {
  //   bool subscribed = Hive.box('subscribed_ogs').containsKey(og.ogId);
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(og.name),
  //       content: SocialButtons(og, true),
  //       actions: <Widget>[
  //         FlatButton(
  //           onPressed: Navigator.of(context).pop,
  //           child: Text('Abbrechen'),
  //         ),
  //         subscribed
  //             ? FlatButton(
  //                 onPressed: () async {
  //                   Hive.box('subscribed_ogs').delete(og.ogId);
  //                   Navigator.of(context).pop();
  //                   setState(() {});
  //                   await FirebaseMessaging()
  //                       .unsubscribeFromTopic('og_${og.ogId}');
  //                 },
  //                 child: Text('Deabonnieren'),
  //               )
  //             : FlatButton(
  //                 onPressed: () async {
  //                   Hive.box('subscribed_ogs').put(og.ogId, og);
  //                   Navigator.of(context).pop();
  //                   setState(() {});
  //                   await FirebaseMessaging().subscribeToTopic('og_${og.ogId}');
  //                 },
  //                 child: Text('Abonnieren'),
  //               ),
  //       ],
  //     ),
  //   );
  // }

  Widget socialMediaMenu() {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        semanticLabel: 'Menü anzeigen',
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Twitter'),
          value: 'tweet',
        ),
        PopupMenuItem(
          child: Text('Instagram'),
          value: 'insta',
        ),
      ],
    );
  }

  Widget _strikeWidget(Strike strike) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text('Datum: '),
              Text(DateFormat('dd.MM.yyyy').format(strike.dateTime))
            ],
          ),
          Row(
            children: [
              Text('Uhrzeit: '),
              Text(DateFormat('HH:mm').format(strike.dateTime)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Treffpunkt: '),
              Flexible(child: Text(strike.location)),
            ],
          ),
          if (strike.additionalInfo.isNotEmpty)
            Row(children: [
              Text('Zusatz Info: '),
              Flexible(child: Text(strike.additionalInfo))
            ]),
          if (strike.eventLink.isNotEmpty)
            Row(
              children: [
                GestureDetector(
                  child: new Text(
                    'Link zum Event',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onTap: () => _launchURL(strike.eventLink),
                ),
              ],
            ),
        ],
      ),
    );
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

    var plenumList =
        strikes.where((strike) => strike.name == 'Nächstes Plenum:');

    Strike nextPlenum = plenumList.length == 0
        ? null
        : plenumList.reduce(
            (curr, next) => curr.date.compareTo(next.date) > 0 ? curr : next);

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            widget.og.name,
            semanticsLabel: widget.og.name,
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
          ),
          trailing: SocialButtons(og, false),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nächstes Plenum: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (nextPlenum == null) Text('Keine Informationen'),
                ],
              ),
              if (nextPlenum != null) _strikeWidget(nextPlenum),
              ListTileTheme(
                contentPadding: EdgeInsets.only(left: 0, right: 12),
                child: ExpansionTile(
                  title: Text(og.infoTitle),
                  children: [
                    DropCapText(
                      og.infoText,
                      dropCap: DropCap(
                        width: 120,
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8),
                          child: Image.network(og.imageLink, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
