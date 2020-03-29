import 'package:app/app.dart';
import 'package:app/service/api.dart';
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
          // TODO TitleWidget when merged `App Theme`
          // TODO Add `System-gesteuert`
          // TODO Pref Management über Hive
          SwitchListTile.adaptive(
              title: Text('Dark Mode aktiviert'),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (val) {
                DynamicTheme.of(context).setBrightness(
                  val ? Brightness.dark : Brightness.light,
                );
              }),
          TitleWidget('Newsfeed Benachrichtigungen'),
          for (String s in feedCategories)
            SwitchListTile.adaptive(
                title: Text(s),
                value: data.get('feed_$s') ?? false,
                onChanged: (val) async {
                  if (val) {
                    await FirebaseMessaging().subscribeToTopic('feed_$s');
                  } else {
                    await FirebaseMessaging().unsubscribeFromTopic('feed_$s');
                  }
                  setState(() {
                    data.put('feed_$s', val);
                  });
                }),
        ],
      ),
    );
  }
}
