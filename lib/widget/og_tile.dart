import 'package:app/model/strike.dart';
import 'package:app/widget/og_social_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/util/share.dart';
import 'dart:io' show Platform;

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
  Strike nextStrike;
  Strike nextPlenum;

  @override
  void initState() {
    super.initState();
    strikes = (Hive.box('strikes').get(og.ogId) ?? []).cast<Strike>();
    _processStrikes();

    _loadData();
  }

  _loadData() async {
    try {
      strikes = await api.getStrikesByOG(og.ogId);
      _processStrikes();
      if (mounted) setState(() {});
      Hive.box('strikes').put(og.ogId, strikes);
    } catch (e) {}
  }

  _processStrikes() {
    List<Strike> plenumList = [];
    List<Strike> strikeList = [];
    for (Strike strike in strikes) {
      strike.name == 'Nächstes Plenum:'
          ? plenumList.insert(0, strike)
          : strikeList.insert(0, strike);
    }

    if (plenumList.length > 0)
      nextPlenum = plenumList.reduce(
          (curr, next) => curr.date.compareTo(next.date) > 0 ? curr : next);

    if (strikeList.length > 0)
      nextStrike = strikeList.reduce(
          (curr, next) => curr.date.compareTo(next.date) > 0 ? curr : next);
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

  Widget _strikeWidget(Strike strike) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Datum: '),
              Text(DateFormat('dd.MM.yyyy').format(strike.dateTime))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Uhrzeit: '),
              Text(DateFormat('HH:mm').format(strike.dateTime)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Treffpunkt: '),
              Flexible(child: Text(strike.location)),
            ],
          ),
          if (strike.additionalInfo.isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Zusatz Info: '),
              Flexible(child: Text(strike.additionalInfo))
            ]),
          if (strike.eventLink.isNotEmpty)
            Row(
              mainAxisSize: MainAxisSize.min,
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
          if (strike.imageUrl != null)
            CachedNetworkImage(imageUrl: strike.imageUrl),
        ],
      ),
    );
  }

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    //Update the next strike for OG
    if (strikes.isNotEmpty) {
      this.nextStrike = strikes.first;
    }

    return Container(
      child: Column(
        children: <Widget>[
          ExpansionTile(
            onExpansionChanged: (value) {
              setState(() {
                _expanded = value;
              });
            },
            title: SizedBox(
              child: Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.og.name,
                      semanticsLabel: widget.og.name,
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 20),
                    ),
                    if (!_expanded && nextStrike != null)
                      Text(
                        'Demo: ${DateFormat('dd.MM.yyyy, HH:mm').format(nextStrike.dateTime)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 12),
                      ),
                    if (!_expanded && nextPlenum != null)
                      Text(
                        'Plenum: ${DateFormat('dd.MM.yyyy, HH:mm').format(nextPlenum.dateTime)}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 12),
                      ),
                  ],
                ),
                Spacer(),
                SocialButtons(og, false),
              ]),
            ),
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Nächste Demo:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                  ),
                                  children: [
                                    if (nextStrike == null)
                                      TextSpan(
                                        text: ' Keine Informationen',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  ]),
                            ),
                            if (nextStrike != null) _strikeWidget(nextStrike),
                          ],
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        if (nextStrike != null)
                          IconButton(
                            icon: Platform.isIOS
                                ? (Icon(CupertinoIcons.share))
                                : Icon(Icons.share),
                            tooltip: 'Termin teilen',
                            onPressed: () {
                              ShareUtil.shareStrike(this.nextStrike);
                            },
                          ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: 'Nächstes Plenum:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                  ),
                                  children: [
                                    if (nextPlenum == null)
                                      TextSpan(
                                        text: ' Keine Informationen',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  ]),
                            ),
                            if (nextPlenum != null) _strikeWidget(nextPlenum),
                          ],
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        if (nextPlenum != null)
                          IconButton(
                            icon: Platform.isIOS
                                ? (Icon(CupertinoIcons.share))
                                : Icon(Icons.share),
                            tooltip: 'Termin teilen',
                            onPressed: () {
                              ShareUtil.sharePlenum(this.nextPlenum);
                            },
                          ),
                        Spacer(),
                      ],
                    ),
                    if (og.infoText != null)
                      ListTileTheme(
                        contentPadding: EdgeInsets.only(left: 0, right: 12),
                        child: ExpansionTile(
                          title: Text(og.infoTitle ?? 'Weitere Infos'),
                          children: [
                            DropCapText(
                              og.infoText,
                              style: Theme.of(context).textTheme.bodyText2,
                              dropCap: og.imageLink == null
                                  ? DropCap(
                                      width: 0,
                                      height: 0,
                                      child: SizedBox(),
                                    )
                                  : DropCap(
                                      width: 120,
                                      height: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8, bottom: 8),
                                        child: Image.network(og.imageLink,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          /*      Divider(
            height: 0.5,
          ), */
        ],
      ),
    );
  }
}
