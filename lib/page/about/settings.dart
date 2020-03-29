import 'package:app/app.dart';
import 'package:app/widget/title.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optionen'),
      ),
      body: ListView(
        children: <Widget>[
          TitleWidget('Design'),
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
          TitleWidget('Abonnierte OGs'),

          for (OG og in Hive.box('subscribed_ogs').values)
            ListTile(
              title: Text(og.name),
              leading: IconButton(
                  icon: Icon(MdiIcons.closeBox),
                  onPressed: () async {
                    await FirebaseMessaging()
                        .unsubscribeFromTopic('og_${og.ogId}');
                    Hive.box('subscribed_ogs').delete(og.ogId);
                    setState(() {});
                  }),
            ),
        ],
      ),
    );
  }
}
