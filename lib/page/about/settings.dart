import 'package:app/app.dart';

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
              })
        ],
      ),
    );
  }
}
