import 'package:app/app.dart';
import 'package:app/model/SocialLinkContainer.dart';
import 'package:app/page/strike/map-netzstreik/netzstreik-api.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButtons extends StatelessWidget {
  SocialLinkContainer container;
  bool compact;

  SocialButtons(this.container, this.compact);
  Widget _buildSocialMedia(IconData icon, String tooltip, String url) {
    if (url == null || url == '') return SizedBox();
    return compact
        ? InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                semanticLabel: tooltip,
                size: 28,
              ),
            ),
            onTap: () => _launchURL(url),
          )
        : ListTile(
            leading: Icon(
              icon,
              semanticLabel: tooltip,
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
        _buildSocialMedia(
            MdiIcons.telegram, 'Telegram Gruppe öffnen', container.telegram),
        _buildSocialMedia(
            MdiIcons.whatsapp, 'WhatsApp Gruppe öffnen', container.whatsapp),
        _buildSocialMedia(
            MdiIcons.instagram, 'Instagram Kanal öffnen', container.instagram),
        _buildSocialMedia(
            MdiIcons.youtube, 'YouTube Kanal öffnen', container.youtube),
        _buildSocialMedia(
            MdiIcons.twitter, 'Twitter Kanal öffnen', container.twitter),
        _buildSocialMedia(
            MdiIcons.facebook, 'Facebook Seite öffnen', container.facebook),
        _buildSocialMedia(
            MdiIcons.email, 'E-Mail an Ortsgruppe schreiben', container.email),
        _buildSocialMedia(
            MdiIcons.web, 'Internetseite öffnen', container.website),
        _buildSocialMedia(
            MdiIcons.link, 'Andere Aktion ausführen', container.other),
      ];
}
