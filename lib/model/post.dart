import 'tag.dart';
import 'author.dart';

class Post {
  String slug;
  String id;
  String uuid;
  String title;
  String html;
  String commentId;
  String featureImage;
  bool featured;
  String visibility;
  String createdAt;
  String updatedAt;
  String publishedAt;
  Null customExcerpt;
  Null codeinjectionHead;
  Null codeinjectionFoot;
  Null customTemplate;
  Null canonicalUrl;
  List<Tag> tags;
  List<Author> authors;
  Author primaryAuthor;
  Tag primaryTag;
  String url;
  String excerpt;
  int readingTime;
  Null ogImage;
  Null ogTitle;
  Null ogDescription;
  Null twitterImage;
  Null twitterTitle;
  Null twitterDescription;
  Null metaTitle;
  Null metaDescription;

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
      this.tags,
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

  Post.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    id = json['id'];
    uuid = json['uuid'];
    title = json['title'];
    html = json['html'];
    commentId = json['comment_id'];
    featureImage = json['feature_image'];
    featured = json['featured'];
    visibility = json['visibility'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    publishedAt = json['published_at'];
    customExcerpt = json['custom_excerpt'];
    codeinjectionHead = json['codeinjection_head'];
    codeinjectionFoot = json['codeinjection_foot'];
    customTemplate = json['custom_template'];
    canonicalUrl = json['canonical_url'];
    if (json['tags'] != null) {
      tags =  List<Tag>();
      json['tags'].forEach((v) {
        tags.add( Tag.fromJson(v));
      });
    }
    if (json['authors'] != null) {
      authors =  List<Author>();
      json['authors'].forEach((v) {
        authors.add( Author.fromJson(v));
      });
    }
    primaryAuthor = json['primary_author'] != null
        ?  Author.fromJson(json['primary_author'])
        : null;
    primaryTag = json['primary_tag'] != null
        ?  Tag.fromJson(json['primary_tag'])
        : null;
    url = json['url'];
    excerpt = json['excerpt'];
    readingTime = json['reading_time'];
    ogImage = json['og_image'];
    ogTitle = json['og_title'];
    ogDescription = json['og_description'];
    twitterImage = json['twitter_image'];
    twitterTitle = json['twitter_title'];
    twitterDescription = json['twitter_description'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['slug'] = this.slug;
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['html'] = this.html;
    data['comment_id'] = this.commentId;
    data['feature_image'] = this.featureImage;
    data['featured'] = this.featured;
    data['visibility'] = this.visibility;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['published_at'] = this.publishedAt;
    data['custom_excerpt'] = this.customExcerpt;
    data['codeinjection_head'] = this.codeinjectionHead;
    data['codeinjection_foot'] = this.codeinjectionFoot;
    data['custom_template'] = this.customTemplate;
    data['canonical_url'] = this.canonicalUrl;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    if (this.authors != null) {
      data['authors'] = this.authors.map((v) => v.toJson()).toList();
    }
    if (this.primaryAuthor != null) {
      data['primary_author'] = this.primaryAuthor.toJson();
    }
    if (this.primaryTag != null) {
      data['primary_tag'] = this.primaryTag.toJson();
    }
    data['url'] = this.url;
    data['excerpt'] = this.excerpt;
    data['reading_time'] = this.readingTime;
    data['og_image'] = this.ogImage;
    data['og_title'] = this.ogTitle;
    data['og_description'] = this.ogDescription;
    data['twitter_image'] = this.twitterImage;
    data['twitter_title'] = this.twitterTitle;
    data['twitter_description'] = this.twitterDescription;
    data['meta_title'] = this.metaTitle;
    data['meta_description'] = this.metaDescription;
    return data;
  }
}
