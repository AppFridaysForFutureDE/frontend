import 'package:json_annotation/json_annotation.dart';

import 'tag.dart';
import 'author.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  String slug;
  String id;
  String uuid;
  String title;
  String html;
  @JsonKey(name: 'comment_id')
  String commentId;
  @JsonKey(name: 'feature_image')
  String featureImage;
  bool featured;
  String visibility;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  @JsonKey(name: 'published_at')
  DateTime publishedAt;
  @JsonKey(name: 'custom_excerpt')
  String customExcerpt;
  @JsonKey(name: 'codeinjection_head')
  String codeinjectionHead;
  @JsonKey(name: 'codeinjection_foot')
  String codeinjectionFoot;
  @JsonKey(name: 'custom_template')
  String customTemplate;
  @JsonKey(name: 'canonical_url')
  String canonicalUrl;
  @JsonKey(name: 'tags')
  List<Tag> tagsInternal;

  @JsonKey(ignore: true)
  List<Tag> get tags => tagsInternal.where((t) => t.name != 'Push').toList();

  List<Author> authors;
  @JsonKey(name: 'primary_author')
  Author primaryAuthor;
  @JsonKey(name: 'primary_tag')
  Tag primaryTag;
  String url;
  String excerpt;
  @JsonKey(name: 'reading_time')
  int readingTime;
  @JsonKey(name: 'og_image')
  String ogImage;
  @JsonKey(name: 'og_title')
  String ogTitle;
  @JsonKey(name: 'og_description')
  String ogDescription;
  @JsonKey(name: 'twitter_image')
  String twitterImage;
  @JsonKey(name: 'twitter_title')
  String twitterTitle;
  @JsonKey(name: 'twitter_description')
  String twitterDescription;
  @JsonKey(name: 'meta_title')
  String metaTitle;
  @JsonKey(name: 'meta_description')
  String metaDescription;

  Post.slug(this.slug);
  Post(
      {this.slug,
      this.id,
      this.uuid,
      this.title,
      this.html,
      this.commentId,
      this.featureImage,
      this.featured,
      this.visibility,
      this.createdAt,
      this.updatedAt,
      this.publishedAt,
      this.customExcerpt,
      this.codeinjectionHead,
      this.codeinjectionFoot,
      this.customTemplate,
      this.canonicalUrl,
      this.authors,
      this.primaryAuthor,
      this.primaryTag,
      this.url,
      this.excerpt,
      this.readingTime,
      this.ogImage,
      this.ogTitle,
      this.ogDescription,
      this.twitterImage,
      this.twitterTitle,
      this.twitterDescription,
      this.metaTitle,
      this.metaDescription});

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
