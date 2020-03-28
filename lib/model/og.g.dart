// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'og.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OG _$OGFromJson(Map<String, dynamic> json) {
  return OG()
    ..id = json['_id'] as String
    ..name = json['name'] as String
    ..bundesland = json['bundesland'] as String
    ..lat = (json['lat'] as num)?.toDouble()
    ..lon = (json['lon'] as num)?.toDouble()
    ..whatsApp = json['whatsApp'] as String
    ..whatsAppStud = json['whatsAppStud'] as String
    ..email = json['email'] as String
    ..instagram = json['instagram'] as String
    ..twitter = json['twitter'] as String
    ..facebook = json['facebook'] as String
    ..website = json['website'] as String
    ..telegram = json['telegram'] as String;
}

Map<String, dynamic> _$OGToJson(OG instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'bundesland': instance.bundesland,
      'lat': instance.lat,
      'lon': instance.lon,
      'whatsApp': instance.whatsApp,
      'whatsAppStud': instance.whatsAppStud,
      'email': instance.email,
      'instagram': instance.instagram,
      'twitter': instance.twitter,
      'facebook': instance.facebook,
      'website': instance.website,
      'telegram': instance.telegram,
    };
