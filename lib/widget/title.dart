import 'dart:io';

import 'package:app/app.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  TitleWidget(this.title);

  /*
  The style of the Sub Headings for Ios.
   */
  /*
  final TextStyle _styleSubHeading = TextStyle(
    letterSpacing: 3,
    color: Colors.black54,
  );*/
  TextStyle _styleSubHeading(BuildContext context) => TextStyle(
        letterSpacing: 3,
        color: Theme.of(context).textTheme.headline6.color,
      );

  /*
  The Background of the Sub headings in IOs
   */
  //final Color _colorSubHeadingBackground = Colors.grey[100];
  Color _colorSubHeadingBackground(BuildContext context) =>
      Theme.of(context).textTheme.subtitle2.backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Material(
            color: _colorSubHeadingBackground(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: Text(
                title,
                style: _styleSubHeading(context),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          );
  }
}
