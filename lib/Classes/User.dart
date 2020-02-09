import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

part 'User.g.dart';

CurrentUser currentUser;

void userInit() => currentUser = new CurrentUser();
bool isSignedIn() => currentUser != null;
void userDelete() {
  Hive.box('currentUser').delete(0);
  currentUser = null;
}

@HiveType(typeId: 0)
class CurrentUser extends HiveObject {
  @HiveField(0)
  String displayName;

  @HiveField(1)
  String email;

  @HiveField(2)
  String uid;

  registerUser(FirebaseUser user) {
    print('displayname');
    print(user.displayName);
    this.displayName = user.displayName;
    this.email = user.email;
    this.uid = user.uid;
    print(this);
    Hive.box('currentUser').put(0, this);
    this.save();
  }
}
