import 'package:json_annotation/json_annotation.dart';

part 'og.g.dart';

@JsonSerializable()
class OG {
  @JsonKey(name: '_id')
  String id;

  String name;

  String bundesland;

  double lat;
  double lon;

  String whatsApp;
  String whatsAppStud;

  String email;
  String instagram;
  String twitter;
  String facebook;
  String website;
  String telegram;

  OG();

  @override
  String toString() {
    return 'OG${toJson()}';
  }

  factory OG.fromJson(Map<String, dynamic> json) => _$OGFromJson(json);

  Map<String, dynamic> toJson() => _$OGToJson(this);
}
