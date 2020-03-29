// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strike.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StrikeAdapter extends TypeAdapter<Strike> {
  @override
  final typeId = 2;

  @override
  Strike read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Strike()
      ..ogId = fields[0] as String
      ..name = fields[1] as String
      ..date = fields[2] as int
      ..startingPoint = fields[3] as String
      ..fbEvent = fields[4] as String
      ..additionalInfo = fields[5] as String;
  }

  @override
  void write(BinaryWriter writer, Strike obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.ogId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.startingPoint)
      ..writeByte(4)
      ..write(obj.fbEvent)
      ..writeByte(5)
      ..write(obj.additionalInfo);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Strike _$StrikeFromJson(Map<String, dynamic> json) {
  return Strike()
    ..ogId = json['ogId'] as String
    ..name = json['name'] as String
    ..date = json['date'] as int
    ..startingPoint = json['startingPoint'] as String
    ..fbEvent = json['fbEvent'] as String
    ..additionalInfo = json['additionalInfo'] as String;
}

Map<String, dynamic> _$StrikeToJson(Strike instance) => <String, dynamic>{
      'ogId': instance.ogId,
      'name': instance.name,
      'date': instance.date,
      'startingPoint': instance.startingPoint,
      'fbEvent': instance.fbEvent,
      'additionalInfo': instance.additionalInfo,
    };
