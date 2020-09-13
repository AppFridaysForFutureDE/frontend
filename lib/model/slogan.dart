import 'package:json_annotation/json_annotation.dart';

part 'slogan.g.dart';

@JsonSerializable()
class Slogan {
  String id;
  String text;
  List<String> tags;

 
  Slogan(
      {this.id,
      this.text,
      this.tags});

  String searchText() {
    String searchFields = (text ?? '') + tags.toString();
    return searchFields.toLowerCase();
  }

  factory Slogan.fromJson(Map<String, dynamic> json) => _$SloganFromJson(json);
  Map<String, dynamic> toJson() => _$SloganToJson(this);
}
