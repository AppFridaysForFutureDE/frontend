// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'og.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OG _$OGFromJson(Map<String, dynamic> json) {
  return OG()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..stadt = json['stadt'] as String
    ..bundesland = json['bundesland'] as String
    ..long = json['long'] as num
    ..lat = json['lat'] as num
    ..zusatzinfo = json['zusatzinfo'] as String
    ..facebook = json['facebook'] as String
    ..instagram = json['instagram'] as String
    ..twitter = json['twitter'] as String
    ..website = json['website'] as String;
}

Map<String, dynamic> _$OGToJson(OG instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'stadt': instance.stadt,
      'bundesland': instance.bundesland,
      'long': instance.long,
      'lat': instance.lat,
      'zusatzinfo': instance.zusatzinfo,
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'twitter': instance.twitter,
      'website': instance.website,
    };
