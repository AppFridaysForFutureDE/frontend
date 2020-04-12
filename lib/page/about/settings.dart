import 'package:app/app.dart';
import 'package:app/service/api.dart';
import 'package:app/service/theme.dart';
import 'package:app/widget/title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Box get data => Hive.box('data');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optionen'),
      ),
      body: ListView(
        children: <Widget>[
          TitleWidget('Design'),
          ListTile(
            title: Text('Erscheinungsbild'),
            trailing: DropdownButton(
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
                }),
          ),
          if (Hive.box('subscribed_ogs').isNotEmpty)
            TitleWidget('Abonnierte Ortsgruppen'),
          for (OG og in Hive.box('subscribed_ogs').values)
            ListTile(
              title: Text(og.name),
              leading: IconButton(
                  icon: Icon(MdiIcons.closeBox),
                  onPressed: () async {
                    Hive.box('subscribed_ogs').delete(og.ogId);
                    setState(() {});
                    await FirebaseMessaging()
                        .unsubscribeFromTopic('og_${og.ogId}');
                  }),
            ),
          TitleWidget('Newsfeed Benachrichtigungen'),
          for (String s in feedCategories)
            SwitchListTile.adaptive(
                title: Text(s),
                value: data.get('feed_$s') ?? false,
                onChanged: (val) async {
                  setState(() {
                    data.put('feed_$s', val);
                  });
                  if (val) {
                    await FirebaseMessaging().subscribeToTopic('feed_$s');
                  } else {
                    await FirebaseMessaging().unsubscribeFromTopic('feed_$s');
                  }
                }),
        ],
      ),
    );
  }
}
