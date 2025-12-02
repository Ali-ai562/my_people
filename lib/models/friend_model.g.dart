// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendModelAdapter extends TypeAdapter<FriendModel> {
  @override
  final typeId = 0;

  @override
  FriendModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendModel(
      fields[0] as Uint8List?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as String?,
      fields[4] as String?,
      fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FriendModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.fatherName)
      ..writeByte(3)
      ..write(obj.mobilePhone)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.descreption);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
