// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strike.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StrikeAdapter extends TypeAdapter<Strike> {
  @override
  final int typeId = 2;

  @override
  Strike read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Strike()
      ..ogId = fields[0] as String
      ..name = fields[1] as String
      ..date = fields[2] as int
      ..location = fields[3] as String
      ..eventLink = fields[4] as String
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
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.eventLink)
      ..writeByte(5)
      ..write(obj.additionalInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrikeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Strike _$StrikeFromJson(Map<String, dynamic> json) {
  return Strike()
    ..ogId = json['ogId'] as String
    ..name = json['name'] as String
    ..date = json['date'] as int
    ..location = json['location'] as String
    ..eventLink = json['eventLink'] as String
    ..additionalInfo = json['additionalInfo'] as String;
}

Map<String, dynamic> _$StrikeToJson(Strike instance) => <String, dynamic>{
      'ogId': instance.ogId,
      'name': instance.name,
      'date': instance.date,
      'location': instance.location,
      'eventLink': instance.eventLink,
      'additionalInfo': instance.additionalInfo,
    };
