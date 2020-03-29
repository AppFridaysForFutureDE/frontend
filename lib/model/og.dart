import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'og.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class OG {
  @HiveField(0)
  String ogId;

  @HiveField(1)
  String name;

  @HiveField(2)
  String bundesland;

  @HiveField(3)
  double lat;
  @HiveField(4)
  double lon;

  @HiveField(5)
  String whatsApp;
  @HiveField(6)
  String whatsAppStud;

  @HiveField(7)
  String email;
  @HiveField(8)
  String instagram;
  @HiveField(9)
  String twitter;
  @HiveField(10)
  String facebook;
  @HiveField(11)
  String website;
  @HiveField(12)
  String telegram;

  OG();

  @override
  String toString() {
    return 'OG${toJson()}';
  }

  factory OG.fromJson(Map<String, dynamic> json) => _$OGFromJson(json);

  Map<String, dynamic> toJson() => _$OGToJson(this);
}
