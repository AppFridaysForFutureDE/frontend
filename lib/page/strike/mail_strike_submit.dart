import 'package:app/app.dart';
import 'package:app/model/politician.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';

class MailStrikeSubmitPage extends StatefulWidget {
  var electionDistrict;

  MailStrikeSubmitPage({Key key, @required this.electionDistrict})
      : super(key: key);

  @override
  _MailStrikeSubmitPageState createState() => _MailStrikeSubmitPageState();
}

class _MailStrikeSubmitPageState extends State<MailStrikeSubmitPage> {
  List<Politician> politicians;
  var currentPolitician;

  @override
  void initState() {
    super.initState();
    // politicians = api.getPoliticiansByElectionDistrict(widget.electionDistrict)

    politicians = [
      Politician('Max Mustermann', "", "CDU", "max@invalid", "crazymaxX"),
//  Politician(this.name, this.imageUrl, this.party, this.email, this.twitter),
    ];

    currentPolitician = politicians[0];
  }

  void _launchMail() {
    launch("mailto:test@t-online.de?subject=Betreff&body=Haaallo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bailout Mail Aktion'),
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /* Image.network(
            'https://app.fffutu.re/img/instagram_instructions.jpg',
          ), */
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            child: Text(
              currentPolitician.name,
              style: TextStyle(fontSize: 16),
            ),
          ),
          RaisedButton(
            onPressed: _launchMail,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
