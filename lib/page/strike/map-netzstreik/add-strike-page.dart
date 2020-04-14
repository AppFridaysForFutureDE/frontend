import '../../../app.dart';
import 'package:email_validator/email_validator.dart';

class AddStrikePage extends StatefulWidget {
  @override
  _AddStrikePageState createState() => _AddStrikePageState();
}

class _AddStrikePageState extends State<AddStrikePage> {
  bool accept = false;
  bool newsletter = false;
  bool showName = true;
  bool hasToAccept = false;

  final nameC = TextEditingController();
  final plzC = TextEditingController();
  final emailC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitButton() {
    if (_formKey.currentState.validate()) {
      if (accept) {
        print(nameC.text + " " + plzC.text + " " + emailC.text);
        hasToAccept = false;
      } else {
        setState(() {
          hasToAccept = true;
        });
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameC.dispose();
    plzC.dispose();
    emailC.dispose();

    super.dispose();
  }

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
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Dein Name', border: OutlineInputBorder()),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Bitte gebe hier deinen Namen ein';
                        }
                        return null;
                      },
                      controller: nameC,
                    ),
                    SwitchListTile.adaptive(
                      title: Text(
                        "Soll dein Name auf der Karte angezeigt werden ",
                        style: Theme.of(context).textTheme.body1,
                      ),
                      value: showName,
                      onChanged: (val) {
                        setState(() {
                          showName = val;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Deine eMail (zur Bestätigung)',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (!EmailValidator.validate(value)) {
                          return 'Bitte gebe eine eMail zu Bestätigung ein';
                        }
                        return null;
                      },
                      controller: emailC,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Postleitzahl',
                            border: OutlineInputBorder()),
                        controller: plzC),
                    Text('Bild Hochladen'),
                    SwitchListTile.adaptive(
                      title: Text(
                          "Ich erkäre mich mit den Datenschutzbedingungen der Aktion einverstanden",
                          style: TextStyle(
                            color: hasToAccept
                                ? Colors.red
                                : Theme.of(context).textTheme.body1.color,
                          )),
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
            onPressed: _submitButton,
          )
        ],
      ),
    );
  }
}
