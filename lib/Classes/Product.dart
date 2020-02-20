import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Product {
  String productName;
  double _price;
  double _discount = 0.0;

  Product({this.productName});

  setDiscount(discount) => this._discount = discount.toDouble();
  hasDiscount() => this._discount > 0.0;
  setPrice(price) => this._price = price.toDouble();
  getPrice() => this._price - ((this._price * this._discount) / 100);
  getOldPrice() => this._price;
}

class ProductRequest {
  String productName;

  ProductRequest({this.productName});
  ProductRequest.retrieveFromDatabase(Map<String, dynamic> data) {
    this.productName = data['productName'];
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
    });
  }
}

class ProductOffer {
  String productName;

  ProductOffer({this.productName});
  ProductOffer.retrieveFromDatabase(Map<String, dynamic> data) {
    this.productName = data['productName'];
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
    });
  }
}
