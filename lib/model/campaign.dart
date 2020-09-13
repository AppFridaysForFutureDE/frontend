import 'package:json_annotation/json_annotation.dart';

part 'campaign.g.dart';
@JsonSerializable()
class Campaign {
  String icon;
  String text;
  String cta;
  String link;
  bool inApp;

  Campaign({this.icon, this.text, this.cta, this.link, this.inApp});

  Campaign.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    text = json['text'];
    cta = json['cta'];
    link = json['link'];
    inApp = json['inApp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['text'] = this.text;
    data['cta'] = this.cta;
    data['link'] = this.link;
    data['inApp'] = this.inApp;
    return data;
  }
}