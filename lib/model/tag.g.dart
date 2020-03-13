// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) {
  return Tag(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
    description: json['description'] as String,
    featureImage: json['feature_image'] as String,
    visibility: json['visibility'] as String,
    metaTitle: json['meta_title'] as String,
    metaDescription: json['meta_description'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'feature_image': instance.featureImage,
      'visibility': instance.visibility,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
      'url': instance.url,
    };
