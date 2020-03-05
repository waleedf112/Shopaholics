import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'User.dart';

class ProductRequest {
  String productName;
  String productDescription;
  int productPrice;
  int time;
  String user;
  double userRating;
  String reference;
  List<File> productImages;
  List productImagesURLs = new List();

  ProductRequest({this.productName, this.productDescription, this.productPrice, this.productImages});
  ProductRequest.retrieveFromDatabase(Map<String, dynamic> data, reference) {
    this.productName = data['productName'];
    this.productDescription = data['productDescription'];
    this.productPrice = data['productPrice'];
    this.time = data['Time'];
    this.userRating = data['User']['Rating'].toDouble();
    this.user = data['User']['displayName'];
    this.productImagesURLs = data['productImagesURLs'];

    this.reference = reference;
  }

  pushToDatabase() async {
    int time = DateTime.now().millisecondsSinceEpoch;
        StorageReference storageReference;

    for (int i = 0; i < this.productImages.length; i++) {
      String path = "ProductImages/Requests/${currentUser.uid}/${this.productName}~$time/$i";
      storageReference = FirebaseStorage.instance.ref().child(path);
      final StorageUploadTask uploadTask = storageReference.putFile(this.productImages[i]);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      productImagesURLs.add(url);
    }
    return await Firestore.instance.collection('ProductRequests').document().setData({
      'User': {
        "uid": currentUser.uid,
        "displayName": currentUser.displayName,
        "Rating": 4.5,
      },
      'Time': time,
      'productName': this.productName,
      'productDescription': this.productDescription,
      'productPrice': this.productPrice,
      'productImagesURLs': this.productImagesURLs,

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
  List<File> productImages;
  List productImagesURLs = new List();

  ProductOffer({this.productName, this.productDescription, this.productPrice, this.productImages});
  ProductOffer.retrieveFromDatabase(Map<String, dynamic> data, reference) {
    this.productName = data['productName'];
    this.productDescription = data['productDescription'];
    this.productPrice = data['productPrice'];
    this.time = data['Time'];
    this.user = data['User']['displayName'];
    this.userRating = data['User']['Rating'].toDouble();
    this.productImagesURLs = data['productImagesURLs'];
    this.reference = reference;
  }

  pushToDatabase() async {
    int time = DateTime.now().millisecondsSinceEpoch;

    StorageReference storageReference;

    for (int i = 0; i < this.productImages.length; i++) {
      String path = "ProductImages/Offers/${currentUser.uid}/${this.productName}~$time/$i";
      storageReference = FirebaseStorage.instance.ref().child(path);
      final StorageUploadTask uploadTask = storageReference.putFile(this.productImages[i]);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      productImagesURLs.add(url);
    }

    return await Firestore.instance.collection('ProductOffer').document().setData({
      'User': {
        "uid": currentUser.uid,
        "displayName": currentUser.displayName,
        "Rating": 4.5,
      },
      'Time': time,
      'productName': this.productName,
      'productDescription': this.productDescription,
      'productPrice': this.productPrice,
      'productImagesURLs': this.productImagesURLs,
    });
  }
}
