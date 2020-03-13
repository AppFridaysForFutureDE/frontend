import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  String id;
  String name;
  String slug;
  String description;
  @JsonKey(name: 'feature_image')
  String featureImage;
  String visibility;
  @JsonKey(name: 'meta_title')
  String metaTitle;
  @JsonKey(name: 'meta_description')
  String metaDescription;
  String url;

  Tag(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.featureImage,
      this.visibility,
      this.metaTitle,
      this.metaDescription,
      this.url});

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}

