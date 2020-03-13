// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    slug: json['slug'] as String,
    id: json['id'] as String,
    uuid: json['uuid'] as String,
    title: json['title'] as String,
    html: json['html'] as String,
    commentId: json['comment_id'] as String,
    featureImage: json['feature_image'] as String,
    featured: json['featured'] as bool,
    visibility: json['visibility'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    publishedAt: json['published_at'] == null
        ? null
        : DateTime.parse(json['published_at'] as String),
    customExcerpt: json['custom_excerpt'] as String,
    codeinjectionHead: json['codeinjection_head'] as String,
    codeinjectionFoot: json['codeinjection_foot'] as String,
    customTemplate: json['custom_template'] as String,
    canonicalUrl: json['canonical_url'] as String,
    tags: (json['tags'] as List)
        ?.map((e) => e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    authors: (json['authors'] as List)
        ?.map((e) =>
            e == null ? null : Author.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    primaryAuthor: json['primary_author'] == null
        ? null
        : Author.fromJson(json['primary_author'] as Map<String, dynamic>),
    primaryTag: json['primary_tag'] == null
        ? null
        : Tag.fromJson(json['primary_tag'] as Map<String, dynamic>),
    url: json['url'] as String,
    excerpt: json['excerpt'] as String,
    readingTime: json['reading_time'] as int,
    ogImage: json['og_image'] as String,
    ogTitle: json['og_title'] as String,
    ogDescription: json['og_description'] as String,
    twitterImage: json['twitter_image'] as String,
    twitterTitle: json['twitter_title'] as String,
    twitterDescription: json['twitter_description'] as String,
    metaTitle: json['meta_title'] as String,
    metaDescription: json['meta_description'] as String,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'slug': instance.slug,
      'id': instance.id,
      'uuid': instance.uuid,
      'title': instance.title,
      'html': instance.html,
      'comment_id': instance.commentId,
      'feature_image': instance.featureImage,
      'featured': instance.featured,
      'visibility': instance.visibility,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'published_at': instance.publishedAt?.toIso8601String(),
      'custom_excerpt': instance.customExcerpt,
      'codeinjection_head': instance.codeinjectionHead,
      'codeinjection_foot': instance.codeinjectionFoot,
      'custom_template': instance.customTemplate,
      'canonical_url': instance.canonicalUrl,
      'tags': instance.tags,
      'authors': instance.authors,
      'primary_author': instance.primaryAuthor,
      'primary_tag': instance.primaryTag,
      'url': instance.url,
      'excerpt': instance.excerpt,
      'reading_time': instance.readingTime,
      'og_image': instance.ogImage,
      'og_title': instance.ogTitle,
      'og_description': instance.ogDescription,
      'twitter_image': instance.twitterImage,
      'twitter_title': instance.twitterTitle,
      'twitter_description': instance.twitterDescription,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
    };
