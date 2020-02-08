import 'package:hive/hive.dart';

part 'User.g.dart';

CurrentUser currentUser;
void userInit()=>currentUser = new CurrentUser();

@HiveType(typeId: 0)
class CurrentUser extends HiveObject{
  @HiveField(0)
  String displayName;
  
  CurrentUser({this.displayName = 'غير مسجل'});

}
