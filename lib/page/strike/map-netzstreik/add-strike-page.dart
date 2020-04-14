import '../../../app.dart';

class AddStrikePage extends StatefulWidget {
  @override
  _AddStrikePageState createState() => _AddStrikePageState();
}

class _AddStrikePageState extends State<AddStrikePage> {
  bool accept = false;
  bool newsletter = false;
  bool showName = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mitstreiken'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Dein Name: ",
                      style: Theme.of(context).textTheme.title,
                    ),
                    TextFormField(),
                    SwitchListTile.adaptive(
                      title: Text("Soll dein Name auf der Karte angezeigt werden "),
                      value: showName,
                      onChanged: (val) {
                        setState(() {
                          showName = val;
                        });
                      },
                    ),
                    Text('Deine eMail (zur Bestätigung):'),
                    TextFormField(),
                    Text('Postleitzahl:'),
                    TextFormField(),
                    Text('Bild Hochladen'),
                    TextFormField(),
                    SwitchListTile.adaptive(
                      title: Text(
                          "Ich erkäre mich mit den Datenschutzbedingungen der Aktion einverstanden"),
                      value: accept,
                      onChanged: (val) {
                        setState(() {
                          accept = val;
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      title: Text(
                          "Ich will über den Newsletter weiterhin über Aktionen informiert werden "),
                      value: newsletter,
                      onChanged: (val) {
                        setState(() {
                          newsletter = val;
                        });
                      },
                    ),
                  ])),
          FlatButton(

            child: Text("Jetzt mitstreiken",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                //Pushes the Sub Page on the Stack
                MaterialPageRoute(builder: (context) => AddStrikePage()),
              );
            },
          )
        ],
      ),
    );
  }
}
