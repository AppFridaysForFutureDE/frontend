// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slogan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slogan _$SloganFromJson(Map<String, dynamic> json) {
  return Slogan(
    id: json['id'] as String,
    text: json['text'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$SloganToJson(Slogan instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'tags': instance.tags,
    };
