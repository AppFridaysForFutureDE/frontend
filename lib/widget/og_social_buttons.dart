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
                size: 28,
              ),
            ),
            onTap: () => _launchURL(url),
          )
        : ListTile(
            leading: Icon(
              icon,
              color: _iconColor,
            ),
            title: Text(url),
            onTap: () => _launchURL(url),
          );
  }

  Color _iconColor;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    _iconColor = Theme.of(context).textTheme.body1.color;
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
        _buildSocialMedia(MdiIcons.whatsapp, og.whatsapp),
        _buildSocialMedia(MdiIcons.instagram, og.instagram),
        _buildSocialMedia(MdiIcons.youtube, og.youtube),
        _buildSocialMedia(MdiIcons.twitter, og.twitter),
        _buildSocialMedia(MdiIcons.facebook, og.facebook),
        _buildSocialMedia(MdiIcons.email, og.email),
        _buildSocialMedia(MdiIcons.web, og.website),
        _buildSocialMedia(MdiIcons.link, og.other),
      ];
}
