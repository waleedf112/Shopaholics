// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppLanguage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppLanguageAdapter extends TypeAdapter<AppLanguage> {
  @override
  final typeId = 2;

  @override
  AppLanguage read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppLanguage.english;
      case 1:
        return AppLanguage.arabic;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, AppLanguage obj) {
    switch (obj) {
      case AppLanguage.english:
        writer.writeByte(0);
        break;
      case AppLanguage.arabic:
        writer.writeByte(1);
        break;
    }
  }
}
