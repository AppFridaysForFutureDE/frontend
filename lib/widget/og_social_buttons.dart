import 'package:app/app.dart';
import 'package:url_launcher/url_launcher.dart';

class OGSocialButtons extends StatelessWidget {
  final OG og;
  final bool compact;

  OGSocialButtons(this.og, this.compact);

  Widget _buildSocialMedia(IconData icon, String url) {
    if (url == null || url == '') return SizedBox();
    return compact
        ? InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 32,
              ),
            ),
            onTap: () => _launchURL(url),
          )
        : ListTile(
            leading: Icon(
              icon,
              color: Theme.of(ctx).textTheme.body1.color,
            ),
            title: Text(url),
            onTap: () => _launchURL(url),
          );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return compact
        ? Wrap(
            children: _buildChildren(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(),
          );
  }

  _buildChildren() => <Widget>[
        _buildSocialMedia(MdiIcons.telegram, og.telegram),
        _buildSocialMedia(MdiIcons.whatsapp, og.whatsApp),
        _buildSocialMedia(MdiIcons.whatsapp, og.whatsAppStud),
        _buildSocialMedia(MdiIcons.instagram, og.instagram),
        _buildSocialMedia(MdiIcons.twitter, og.twitter),
        _buildSocialMedia(MdiIcons.facebook, og.facebook),
        _buildSocialMedia(MdiIcons.email, og.email),
        _buildSocialMedia(MdiIcons.web, og.website),
      ];
}
