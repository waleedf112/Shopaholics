import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class ProductRequest {
  String productName;
  String productDescription;
  int productPrice;
  int time;
  String user;
  double userRating;
  String reference;

  ProductRequest({this.productName, this.productDescription, this.productPrice});
  ProductRequest.retrieveFromDatabase(Map<String, dynamic> data, reference) {
    this.productName = data['productName'];
    this.productDescription = data['productDescription'];
    this.productPrice = data['productPrice'];
    this.time = data['Time'];
    this.userRating = data['User']['Rating'].toDouble();
    this.user = data['User']['displayName'];
    this.reference = reference;
  }

  pushToDatabase() async {
    return await Firestore.instance.collection('ProductRequests').document().setData({
      'User': {
        "uid": currentUser.uid,
        "displayName": currentUser.displayName,
        "Rating": 4.5,
      },
      'Time': DateTime.now().millisecondsSinceEpoch,
      'productName': this.productName,
      'productDescription': this.productDescription,
      'productPrice': this.productPrice,
    });
  }
}

class ProductOffer {
  String productName;
  String productDescription;
  int productPrice;
  int time;
  String user;
  String reference;
  double userRating;

  ProductOffer({this.productName, this.productDescription, this.productPrice});
  ProductOffer.retrieveFromDatabase(Map<String, dynamic> data, reference) {
    this.productName = data['productName'];
    this.productDescription = data['productDescription'];
    this.productPrice = data['productPrice'];
    this.time = data['Time'];
    this.user = data['User']['displayName'];
    this.userRating = data['User']['Rating'].toDouble();

    this.reference = reference;
  }

  pushToDatabase() async {
    return await Firestore.instance.collection('ProductOffer').document().setData({
      'User': {
        "uid": currentUser.uid,
        "displayName": currentUser.displayName,
        "Rating": 4.5,
      },
      'Time': DateTime.now().millisecondsSinceEpoch,
      'productName': this.productName,
      'productDescription': this.productDescription,
      'productPrice': this.productPrice,
    });
  }
}
