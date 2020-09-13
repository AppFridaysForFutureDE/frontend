import 'package:app/app.dart';
import 'package:app/model/SocialLinkContainer.dart';
import 'package:app/page/strike/map-netzstreik/netzstreik-api.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialButtons extends StatelessWidget {
  SocialLinkContainer container;
  bool compact;

  SocialButtons(this.container, this.compact);

  Widget _buildSocialMedia(SocialLink socialLink) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          socialLink.icon,
          semanticLabel: socialLink.label,
          size: 28,
        ),
      ),
      onTap: () => _launchURL(socialLink.link),
    );
  }

  _buildSocialMediaPopupList() {
    var list = [
      for (var socialLink in _buildList())
        PopupMenuItem(
          child: Text(socialLink.label),
          value: socialLink.link,
        ),
    ];

    return list.isEmpty
        ? [
            PopupMenuItem(
              child: Text('Keine Informationen'),
              value: null,
            )
          ]
        : list;
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
        ? Wrap(children: [
            for (var socialLink in _buildList()) _buildSocialMedia(socialLink)
          ])
        : PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              semanticLabel: 'Social Media anzeigen',
            ),
            onSelected: (link) {
              _launchURL(link);
            },
            itemBuilder: (context) => _buildSocialMediaPopupList(),
          );
  }

  List<SocialLink> _buildList() {
    var list = [
      SocialLink(
          MdiIcons.telegram, 'Telegram Gruppe öffnen', container.telegram),
      SocialLink(
          MdiIcons.instagram, 'Instagram Kanal öffnen', container.instagram),
      SocialLink(MdiIcons.youtube, 'YouTube Kanal öffnen', container.youtube),
      SocialLink(MdiIcons.twitter, 'Twitter Kanal öffnen', container.twitter),
      SocialLink(
          MdiIcons.facebook, 'Facebook Seite öffnen', container.facebook),
      SocialLink(
          MdiIcons.email, 'E-Mail an Ortsgruppe schreiben', container.email),
      SocialLink(MdiIcons.web, 'Internetseite öffnen', container.website),
      SocialLink(MdiIcons.link, 'Andere Aktion ausführen', container.other),
    ];
    list.removeWhere((socialLink) => socialLink.link == "");
    return list;
  }
}

class SocialLink {
  IconData icon;
  String label;
  String link;

  SocialLink(this.icon, this.label, this.link);
}
