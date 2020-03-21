import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class TradeOffer {
  int price;
  String info;
  int requestId;
  String traderUid;
  Map traderLocation;

  TradeOffer({this.price, this.info, this.requestId});

  Future<void> makeOffer() async {
    await Firestore.instance
        .collection('ProductRequests')
        .document(this.requestId.toString())
        .collection('offers')
        .document(currentUser.uid)
        .setData({
      'price': this.price,
      'info': this.info,
      'requestId': this.requestId,
      'traderUid': currentUser.uid,
      'traderLocation': currentUser.location,
    });
  }
}
