import 'package:app/app.dart';
import 'package:app/service/api.dart';
import 'package:app/service/theme.dart';
import 'package:app/widget/title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

//Setting the theme to show theme name correctly in iOS action sheet
String themeShow = '';
void setThemeName(data) {
  String theme = data.get('theme') ?? 'light';
  switch (theme) {
    case 'light':
      themeShow = 'Hell';
      break;
    case 'sepia':
      themeShow = 'Sepia';
      break;
    case 'dark':
      themeShow = 'Dunkel';
      break;
    case 'black':
      themeShow = 'Schwarz';
  }
}

class _SettingsPageState extends State<SettingsPage> {
  Box get data => Hive.box('data');
  @override
  Widget build(BuildContext context) {
    setThemeName(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('Optionen'),
      ),
      body: ListView(
        children: <Widget>[
          Semantics(
            label: 'Design. Bereichsüberschrift',
            child: TitleWidget('Design'),
          ),
          ListTile(
              title: Text('Erscheinungsbild'),
              trailing: Platform.isAndroid
                  ? DropdownButton(
                      value: data.get('theme') ?? 'light',
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'Hell',
                          ),
                          value: 'light',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Sepia',
                          ),
                          value: 'sepia',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Dunkel',
                          ),
                          value: 'dark',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            'Schwarz',
                          ),
                          value: 'black',
                        ),
                      ],
                      onChanged: (val) {
                        AppTheme.of(context).setTheme(
                          val,
                        );
                      })
                  :
                  //iOS adaption:
                  CupertinoButton(
                      child: Text(themeShow),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Text('Thema auswählen:'),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text('Hell'),
                                    onPressed: () {
                                      AppTheme.of(context).setTheme('light');
                                      //update the button's name
                                      setThemeName(data);
                                      //dismiss
                                      Navigator.pop(context, 'light');
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('Sepia'),
                                    onPressed: () {
                                      AppTheme.of(context).setTheme('sepia');
                                      setThemeName(data);
                                      Navigator.pop(context, 'sepia');
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('Dunkel'),
                                    onPressed: () {
                                      AppTheme.of(context).setTheme('dark');
                                      setThemeName(data);
                                      Navigator.pop(context, 'dark');
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: Text('Schwarz'),
                                    onPressed: () {
                                      AppTheme.of(context).setTheme('black');
                                      setThemeName(data);
                                      Navigator.pop(context, 'black');
                                    },
                                  )
                                ],
                                //cancel button
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text('Abbrechen'),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context, 'Cancel');
                                  },
                                ),
                              );
                            });
                      },
                    )),
          if (Hive.box('subscribed_ogs').isNotEmpty)
            Semantics(
              label: 'Abonnierte Ortsgruppen. Bereichsüberschrift',
              child: TitleWidget('Abonnierte Ortsgruppen'),
            ),
          for (OG og in Hive.box('subscribed_ogs').values)
            //Delete an og with swipe to left or right (common on iOS)
            /*Dismissible(
              key: Key('OGs'),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                Hive.box('subscribed_ogs').delete(og.ogId);
                setState(() {});
                await FirebaseMessaging().unsubscribeFromTopic('og_${og.ogId}');
              },
              child: */
            ListTile(
              title: Text(og.name),
              leading: IconButton(
                  icon: Platform.isIOS
                      ? Icon(CupertinoIcons.minus_circled)
                      : Icon(MdiIcons.minusBox),
                  tooltip: 'Ortsgruppe deabonnieren',
                  onPressed: () async {
                    Hive.box('subscribed_ogs').delete(og.ogId);
                    setState(() {});
                    await FirebaseMessaging.instance
                        .unsubscribeFromTopic('og_${og.ogId}');
                  }),
            ),
          //),
          Semantics(
            label: 'Newsfeed Benachrichtigungen. Bereichsüberschrift',
            child: TitleWidget('Newsfeed Benachrichtigungen'),
          ),
          for (String s in feedCategories)
            SwitchListTile.adaptive(
                title: Text(s),
                value: data.get('feed_$s') ?? false,
                onChanged: (val) async {
                  setState(() {
                    data.put('feed_$s', val);
                  });
                  if (val) {
                    await FirebaseMessaging.instance
                        .subscribeToTopic('feed_$s');
                  } else {
                    await FirebaseMessaging.instance
                        .unsubscribeFromTopic('feed_$s');
                  }
                }),
          Center(
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, result) {
                if (!result.hasData) return SizedBox();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Dies ist die offizielle App von Fridays for Future Deutschland in der Version ${result.data.version}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
