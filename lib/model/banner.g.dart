// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banner _$BannerFromJson(Map<String, dynamic> json) {
  return Banner(
    imageUrl: json['imageUrl'] as String,
    link: json['link'] as String,
    inApp: json['inApp'] as bool,
  );
}

Map<String, dynamic> _$BannerToJson(Banner instance) => <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'link': instance.link,
      'inApp': instance.inApp,
    };
