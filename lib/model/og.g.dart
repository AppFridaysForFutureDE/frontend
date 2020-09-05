// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'og.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OGAdapter extends TypeAdapter<OG> {
  @override
  final int typeId = 1;

  @override
  OG read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OG()
      ..ogId = fields[0] as String
      ..name = fields[1] as String
      ..bundesland = fields[2] as String
      ..lat = fields[3] as double
      ..lon = fields[4] as double
      ..whatsapp = fields[5] as String
      ..email = fields[7] as String
      ..instagram = fields[8] as String
      ..twitter = fields[9] as String
      ..facebook = fields[10] as String
      ..website = fields[11] as String
      ..telegram = fields[12] as String
      ..youtube = fields[13] as String
      ..other = fields[14] as String;
  }

  @override
  void write(BinaryWriter writer, OG obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.ogId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bundesland)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lon)
      ..writeByte(5)
      ..write(obj.whatsapp)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.instagram)
      ..writeByte(9)
      ..write(obj.twitter)
      ..writeByte(10)
      ..write(obj.facebook)
      ..writeByte(11)
      ..write(obj.website)
      ..writeByte(12)
      ..write(obj.telegram)
      ..writeByte(13)
      ..write(obj.youtube)
      ..writeByte(14)
      ..write(obj.other);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OGAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OG _$OGFromJson(Map<String, dynamic> json) {
  return OG()
    ..ogId = json['ogId'] as String
    ..name = json['name'] as String
    ..bundesland = json['bundesland'] as String
    ..lat = (json['lat'] as num)?.toDouble()
    ..lon = (json['lon'] as num)?.toDouble()
    ..whatsapp = json['whatsapp'] as String
    ..email = json['email'] as String
    ..instagram = json['instagram'] as String
    ..twitter = json['twitter'] as String
    ..facebook = json['facebook'] as String
    ..website = json['website'] as String
    ..telegram = json['telegram'] as String
    ..youtube = json['youtube'] as String
    ..other = json['other'] as String;
}

Map<String, dynamic> _$OGToJson(OG instance) => <String, dynamic>{
      'ogId': instance.ogId,
      'name': instance.name,
      'bundesland': instance.bundesland,
      'lat': instance.lat,
      'lon': instance.lon,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'instagram': instance.instagram,
      'twitter': instance.twitter,
      'facebook': instance.facebook,
      'website': instance.website,
      'telegram': instance.telegram,
      'youtube': instance.youtube,
      'other': instance.other,
    };
