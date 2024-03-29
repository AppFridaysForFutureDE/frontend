import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'strike.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Strike {
  @HiveField(0)
  String ogId;

  @HiveField(1)
  String name;

  @HiveField(2)
  int date;

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(date * 1000);

  @HiveField(3)
  String location;

  @HiveField(4)
  String eventLink;

  @HiveField(5)
  String additionalInfo;

  @HiveField(6)
  @JsonKey()
  String imageUrl;

  Strike();

  @override
  String toString() {
    return 'Strike${toJson()}';
  }

  factory Strike.fromJson(Map<String, dynamic> json) => _$StrikeFromJson(json);

  Map<String, dynamic> toJson() => _$StrikeToJson(this);
}
