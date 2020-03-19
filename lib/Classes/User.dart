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
        await this.requestRole(UserRole.customer, true);
      } else {
        this.role = UserRole.values[value.data['role']['currentRole']];
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
        'role': {
          'currentRole': this.role.index,
          'requestedRole': -1,
          'pending': false,
        }
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

  Future<void> updateData() async {
    await Firestore.instance.collection('Users').document(this.uid).get().then((value) async {
      if (value.exists) {
        if (value.data['role'] == null) {
          await this.requestRole(UserRole.customer, true);
        } else {
          this.role = UserRole.values[value.data['role']['currentRole']];
        }
      }
    });
  }

  Future<void> requestRole(UserRole role, [bool forced = false]) async {
    await Firestore.instance.collection('Users').document(this.uid).updateData({
      'role': {
        'currentRole': this.role.index,
        'requestedRole': forced ? -1 : role.index,
        'pending': forced ? false : true,
      }
    });
  }

  Future getRequestedRole() async {
    return await Firestore.instance.collection('Users').document(this.uid).get().then((onValue) async {
      if (onValue.data['role'] == null) {
        this.requestRole(UserRole.customer, true);

        return (await Firestore.instance.collection('Users').document(this.uid).get()).data['role'];
      } else {
        return onValue.data['role'];
      }
    });
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

  Future<void> addOfferToCart(int item) async {
    await Firestore.instance
        .collection('Users')
        .document(this.uid)
        .collection('cart')
        .document(item.toString())
        .get()
        .then((onValue) async {
      if (onValue.exists) {
        await Firestore.instance
            .collection('Users')
            .document(this.uid)
            .collection('cart')
            .document(item.toString())
            .updateData({'count': FieldValue.increment(1)});
      } else {
        await Firestore.instance
            .collection('Users')
            .document(this.uid)
            .collection('cart')
            .document(item.toString())
            .setData({'product': item, 'count': 1});
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    List<DocumentSnapshot> documents =
        (await Firestore.instance.collection('Users').document(this.uid).collection('cart').getDocuments()).documents;
    List<Map<String, dynamic>> cart = new List();
    for (DocumentSnapshot doc in documents) {
      Map product =
          (await Firestore.instance.collection('ProductOffer').document(doc.data['product'].toString()).get()).data;

      int count = doc.data['count'];
      cart.add({'product': product, 'count': count});
    }

    return Future.value(cart);
  }

  Future<void> modifyItemInCart({int quantity, String ref}) async {
    if (quantity == 0)
      Firestore.instance.collection('Users').document(this.uid).collection('cart').document(ref).delete();
    else
      Firestore.instance
          .collection('Users')
          .document(this.uid)
          .collection('cart')
          .document(ref)
          .updateData({'count': quantity});
  }

  Future<void> emptyCart() {
    Firestore.instance.collection('Users').document(this.uid).collection('cart').getDocuments().then((onValue) {
      onValue.documents.forEach((doc) async {
        await Firestore.instance
            .collection('Users')
            .document(this.uid)
            .collection('cart')
            .document(doc.documentID)
            .delete();
      });
    });
  }
}
