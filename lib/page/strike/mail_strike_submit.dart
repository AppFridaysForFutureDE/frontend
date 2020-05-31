import 'package:app/app.dart';
import 'package:app/model/politician.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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

  // TODO: api.getMailSubjectByPoliticalParty(currentPolitician.party)
  var mailSubject = 'Konjunkturmaßnahmen müssen an Klimaziele gebunden werden!';

  // TODO: api.getMailBodyByPoliticalParty(currentPolitician.party)
  var mailBody = 'Inhalt';

  @override
  void initState() {
    super.initState();
    // politicians = api.getPoliticiansByElectionDistrict(widget.electionDistrict)

    politicians = [
      Politician(
          'Max Mustermann',
          "https://app.fffutu.re/img/instagram_instructions.jpg",
          "CDU",
          "max@invalid",
          "crazymaxX"),
//  Politician(this.name, this.imageUrl, this.party, this.email, this.twitter),
    ];

    currentPolitician = politicians[0];
    // TODO: set mail subject + body
  }

  // TODO: Fix Layout
  Widget _copyableText(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(text),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: text));
                      },
                      child: Text('Clipboard'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
          Image.network(currentPolitician.imageUrl),
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
          Text(currentPolitician.party),
          RaisedButton(
            onPressed: () {
              launch(
                  "mailto:${currentPolitician.email}?subject=$mailSubject&body=$mailBody");
            },
            child: Text('Mail App öffnen'),
          ),
          _copyableText(currentPolitician.email),
          _copyableText(mailSubject),
          _copyableText(mailBody),
        ],
      ),
    );
  }
}
