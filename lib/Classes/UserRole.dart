import 'package:hive/hive.dart';
import 'package:shopaholics/Functions/AppLanguage.dart';

part 'UserRole.g.dart';

@HiveType(typeId: 1)
enum UserRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  personalShopper,
  @HiveField(2)
  customer
}
List<String> roleNames() {
  if (currentAppLanguage == AppLanguage.arabic) return ['مشرف', 'متسوق شخصي', 'زبون'];
  return ['Admin', 'Personal Shopper', 'Customer'];
}
