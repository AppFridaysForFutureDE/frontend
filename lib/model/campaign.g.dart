// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Campaign _$CampaignFromJson(Map<String, dynamic> json) {
  return Campaign(
    icon: json['icon'] as String,
    text: json['text'] as String,
    cta: json['cta'] as String,
    link: json['link'] as String,
    inApp: json['inApp'] as bool,
  );
}

Map<String, dynamic> _$CampaignToJson(Campaign instance) => <String, dynamic>{
      'icon': instance.icon,
      'text': instance.text,
      'cta': instance.cta,
      'link': instance.link,
      'inApp': instance.inApp,
    };
