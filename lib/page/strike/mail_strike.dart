import 'package:app/app.dart';
import 'package:flutter/rendering.dart';

class MailStrikePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bailout Mail Aktion'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
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
              '''Wähle einen Politiker deines Landkreises aus und sende ihm eine Mail. Wir haben für dich bereits alle Informationen gesammelt und einen Text vorbereitet. Du musst nur noch einen Politiker auswählen und die Email absenden.''',
              style: TextStyle(fontSize: 16),
            ),
          ),
          // PLZ Input
        ],
      ),
    );
  }
}
