import 'package:cloud_firestore/cloud_firestore.dart';
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

  registerUser(FirebaseUser user) async {

    void fetchUserFromDatabase(DocumentSnapshot value) {
      this.displayName = value.data['displayName'];
    }

    Future<void> createUserInDatabase() async {
      await Firestore.instance.collection('Users').document(this.uid).setData({
        'uid': this.uid,
        'email': this.email,
        'displayName': this.displayName,
      });
    }

    this.uid = user.uid;
    this.email = user.email;
    this.displayName = 'بدون اسم';

    await Firestore.instance.collection('Users').document(this.uid).get().then((value) async {
      if (value.exists) {
        fetchUserFromDatabase(value);
      } else {
        await createUserInDatabase();
      }
    });
    
    Hive.box('currentUser').put(0, this);
    this.save();
  }
}
