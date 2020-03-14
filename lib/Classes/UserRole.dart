import 'package:hive/hive.dart';

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

const List<String> roleNames = ['مشرف', 'متسوق شخصي', 'زبون'];
