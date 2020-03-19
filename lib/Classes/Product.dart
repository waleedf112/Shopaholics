import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
    this.userRating = data['Rating'].toDouble();
    this.user = data['displayName'];
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
    int counter;
    await Firestore.instance.collection('Counters').document('requestsID').get().then((counterValue) {
      counter = counterValue.data['id'];
    });
    await Firestore.instance.collection('Counters').document('requestsID').updateData({
      'id': FieldValue.increment(1),
    });

    return await Firestore.instance.collection('ProductRequests').document(counter.toString()).setData({
      "uid": currentUser.uid,
      "displayName": currentUser.displayName,
      "Rating": 4.5,
      'Time': time,
      'id': counter,
      'productName': this.productName,
      'productDescription': this.productDescription,
      'productPrice': this.productPrice,
      'productImagesURLs': this.productImagesURLs,
    });
  }

  bool isLiked() => false;
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

    int counter;
    await Firestore.instance.collection('Counters').document('offersID').get().then((counterValue) {
      counter = counterValue.data['id'];
    });
    await Firestore.instance.collection('Counters').document('offersID').updateData({
      'id': FieldValue.increment(1),
    });
    return await Firestore.instance.collection('ProductOffer').document(counter.toString()).setData({
      'User': {
        "uid": currentUser.uid,
        "displayName": currentUser.displayName,
        "Rating": 4.5,
      },
      'Time': time,
      'id': counter,
      'productName': this.productName,
      'productDescription': this.productDescription,
      'productPrice': this.productPrice,
      'productImagesURLs': this.productImagesURLs,
    });
  }

  void addToLikes() {
    currentUser.addOfferToLikes(this.reference.split('/')[1]);
  }

  void addToCart() {
    currentUser.addOfferToCart(int.parse(this.reference.split('/')[1]));
  }

  void removeFromLikes() {
    currentUser.removeOfferToLikes(this.reference.split('/')[1]);
  }

  bool isLiked() {
    try {
      return currentUser.likedOffers.contains(int.parse(reference.split('/')[1]));
    } catch (e) {
      return false;
    }
  }
}
