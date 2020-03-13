import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  String id;
  String name;
  String slug;
  @JsonKey(name: 'profile_image')
  String profileImage;
  @JsonKey(name: 'cover_image')
  String coverImage;
  String bio;
  String website;
  String location;
  String facebook;
  String twitter;
  @JsonKey(name: 'meta_title')
  String metaTitle;
  @JsonKey(name: 'meta_description')
  String metaDescription;
  String url;

  Author(
      {this.id,
      this.name,
      this.slug,
      this.profileImage,
      this.coverImage,
      this.bio,
      this.website,
      this.location,
      this.facebook,
      this.twitter,
      this.metaTitle,
      this.metaDescription,
      this.url});

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
