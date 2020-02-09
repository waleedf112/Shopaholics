// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentUserAdapter extends TypeAdapter<CurrentUser> {
  @override
  final typeId = 0;

  @override
  CurrentUser read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUser()
      ..displayName = fields[0] as String
      ..email = fields[1] as String
      ..uid = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, CurrentUser obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.displayName)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.uid);
  }
}
