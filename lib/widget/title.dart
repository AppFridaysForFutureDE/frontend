import 'dart:io';

import 'package:app/app.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  TitleWidget(this.title);

  /*
  The style of the Sub Headings.
   */
  final TextStyle _styleSubHeading = TextStyle(
    letterSpacing: 3,
    color: Colors.black54,
  );

  /*
  The Background of the Sub headings
   */
  final Color _colorSubHeadingBackground = Colors.grey[100];

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Material(
            color: _colorSubHeadingBackground,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                title,
                style: _styleSubHeading,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
          );
  }
}
