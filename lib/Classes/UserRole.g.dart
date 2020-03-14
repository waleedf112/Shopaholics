// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserRole.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final typeId = 1;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.admin;
      case 1:
        return UserRole.personalShopper;
      case 2:
        return UserRole.customer;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.admin:
        writer.writeByte(0);
        break;
      case UserRole.personalShopper:
        writer.writeByte(1);
        break;
      case UserRole.customer:
        writer.writeByte(2);
        break;
    }
  }
}
