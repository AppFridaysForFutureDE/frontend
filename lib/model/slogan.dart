import 'package:json_annotation/json_annotation.dart';

part 'slogan.g.dart';

@JsonSerializable()
class Slogan {
  String id;
  String title;
  String description;
  List<String> tags;

 
  Slogan(
      {this.id,
      this.title,
      this.description,
      this.tags});

  factory Slogan.fromJson(Map<String, dynamic> json) => _$SloganFromJson(json);
  Map<String, dynamic> toJson() => _$SloganToJson(this);
}
