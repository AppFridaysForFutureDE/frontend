import 'package:json_annotation/json_annotation.dart';

part 'og.g.dart';

@JsonSerializable()
class OG {
  String id;

  String name;
  String stadt;
  String bundesland;

  num long;
  num lat;

  String zusatzinfo;

  String facebook;
  String instagram;
  String twitter;
  String website;

  OG();

  @override
  String toString() {
    return 'OG[id=$id, name=$name, stadt=$stadt, bundesland=$bundesland, long=$long, lat=$lat, zusatzinfo=$zusatzinfo, facebook=$facebook, instagram=$instagram, twitter=$twitter, website=$website]';
  }

  factory OG.fromJson(Map<String, dynamic> json) => _$OGFromJson(json);

  Map<String, dynamic> toJson() => _$OGToJson(this);
}
