import 'package:app/app.dart';
import 'package:app/model/SocialLinkContainer.dart';
import 'package:app/page/strike/map-netzstreik/netzstreik-api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

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

//for android
  _buildSocialMediaPopupList() {
    var list = [
      for (var socialLink in _buildList())
        PopupMenuItem(
          child: Row(
            children: [
              Icon(socialLink.icon),
              SizedBox(
                width: 8,
              ),
              Text(socialLink.label),
            ],
          ),
          value: socialLink.link,
        )
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

//for ios
  _buildSocialMediaPopupListIOS() {
    var list = [
      for (var socialLink in _buildList())
        CupertinoActionSheetAction(
          child: Row(
            children: [
              Icon(socialLink.icon),
              SizedBox(
                width: 8,
              ),
              Text(socialLink.label),
            ],
          ),
          onPressed: () {
            _launchURL(socialLink.link);
        },
        )
    ];
    return list.isEmpty
        ? [
            CupertinoActionSheetAction(
              onPressed: () {  },
              child: Text('Keine Informationen'),
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
        : Platform.isAndroid?
        PopupMenuButton(
            icon: Icon(Icons.more_vert,
              semanticLabel: 'Social Media anzeigen',
            ),
            onSelected: (link) {
              _launchURL(link);
            },
            itemBuilder: (context) => _buildSocialMediaPopupList(),
          )
          :

          //ios adaption:
          FlatButton(
          onPressed: () { 
            showCupertinoModalPopup(
            context: context,
            builder: (context) {
            return CupertinoActionSheet(
            actions: _buildSocialMediaPopupListIOS(),
          //cancel button
              cancelButton: CupertinoActionSheetAction(
              child: const Text('Abbrechen'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              ),
          );
        });
      },
      child: Icon(CupertinoIcons.ellipsis, semanticLabel: 'Social Media anzeigen'));
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
