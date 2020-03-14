import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import 'UserRole.dart';

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

  @HiveField(3)
  String phone;

  @HiveField(4)
  List<int> likedOffers;

  @HiveField(5)
  UserRole role;

  CurrentUser() {
    this.role = UserRole.customer;
  }

  void setName(String name) {
    this.displayName = name;
    this.save();
  }

  void registerUser(FirebaseUser user, [String name, String phone]) async {
    Future<void> fetchUserFromDatabase(DocumentSnapshot value) async {
      if (value.data['role'] == null) {
        await this.setRole(UserRole.customer);
      } else {
        this.role = UserRole.values[value.data['role']];
      }
      this.displayName = value.data['displayName'];
      this.phone = value.data['phone'];
    }

    Future<void> createUserInDatabase() async {
      await Firestore.instance.collection('Users').document(this.uid).setData({
        'uid': this.uid,
        'email': this.email,
        'displayName': this.displayName,
        'phone': this.phone,
        'role': this.role.index,
      });
    }

    this.uid = user.uid;
    this.email = user.email;
    this.displayName = name;
    this.phone = phone;
    this.role = UserRole.customer;

    await Firestore.instance.collection('Users').document(this.uid).get().then((value) async {
      if (value.exists) {
        await fetchUserFromDatabase(value);
      } else {
        await createUserInDatabase();
      }
    });

    Hive.box('currentUser').put(0, this);
    this.save();
  }

  Future<void> setRole(UserRole role) async {
    this.role = role;
    await Firestore.instance.collection('Users').document(this.uid).updateData({
      'role': this.role.index,
    });
    this.save();
  }

  int getRole() => this.role.index;

  Future<void> resetPassword(String password) async =>
      (await FirebaseAuth.instance.currentUser()).updatePassword(password);

  Future<void> updatePhoneNumber(String phoneNumber) async {
    this.phone = phoneNumber;
    this.save();
    return await Firestore.instance.collection('Users').document(this.uid).updateData({
      'phone': this.phone,
    });
  }

  Future<void> saveUserChanges() async {
    this.save();
    await Firestore.instance.collection('Users').document(this.uid).updateData({
      'displayName': this.displayName,
    });
  }

  Future<void> addOfferToLikes(String reference) async {
    try {
      await Firestore.instance
          .collection('Users')
          .document(this.uid)
          .collection('favorite')
          .document('offers')
          .updateData({
        'reference': FieldValue.arrayUnion([reference]),
      });
    } catch (e) {
      await Firestore.instance
          .collection('Users')
          .document(this.uid)
          .collection('favorite')
          .document('offers')
          .setData({'reference': []});
      await Firestore.instance
          .collection('Users')
          .document(this.uid)
          .collection('favorite')
          .document('offers')
          .updateData({
        'reference': FieldValue.arrayUnion([reference]),
      });
    }
    if (this.likedOffers == null) this.likedOffers = new List();
    this.likedOffers.add(int.parse(reference));
    print(currentUser.likedOffers);
    this.save();
  }

  Future<void> removeOfferToLikes(String reference) async {
    try {
      await Firestore.instance
          .collection('Users')
          .document(this.uid)
          .collection('favorite')
          .document('offers')
          .updateData({
        'reference': FieldValue.arrayRemove([reference]),
      });
    } catch (e) {
      await Firestore.instance
          .collection('Users')
          .document(this.uid)
          .collection('favorite')
          .document('offers')
          .setData({'reference': []});
    }
    if (this.likedOffers == null) this.likedOffers = new List();

    this.likedOffers.remove(int.parse(reference));

    this.save();
  }

  Stream<QuerySnapshot> getLikedOffers() => this.likedOffers == null || this.likedOffers.isEmpty
      ? null
      : Firestore.instance.collection('ProductOffer').where('id', whereIn: this.likedOffers).getDocuments().asStream();
}
