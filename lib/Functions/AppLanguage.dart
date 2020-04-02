import 'package:hive/hive.dart';
part 'AppLanguage.g.dart';

@HiveType(typeId: 2)
enum AppLanguage {
  @HiveField(0)
  english,
  @HiveField(1)
  arabic
}
AppLanguage currentAppLanguage;
void getCurrentAppLanguage() => currentAppLanguage = Hive.box('currentAppLanguage').get(0);
Future<void> setCurrentAppLanguage(AppLanguage language) => Hive.box('currentAppLanguage').put(0, language);
