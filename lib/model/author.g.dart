// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return Author(
    id: json['id'] as String,
    name: json['name'] as String,
    slug: json['slug'] as String,
    profileImage: json['profile_image'] as String,
    coverImage: json['cover_image'] as String,
    bio: json['bio'] as String,
    website: json['website'] as String,
    location: json['location'] as String,
    facebook: json['facebook'] as String,
    twitter: json['twitter'] as String,
    metaTitle: json['meta_title'] as String,
    metaDescription: json['meta_description'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'profile_image': instance.profileImage,
      'cover_image': instance.coverImage,
      'bio': instance.bio,
      'website': instance.website,
      'location': instance.location,
      'facebook': instance.facebook,
      'twitter': instance.twitter,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
      'url': instance.url,
    };
