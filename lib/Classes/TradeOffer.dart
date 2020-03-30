import 'package:cloud_firestore/cloud_firestore.dart';

import 'Order.dart';
import 'User.dart';

class TradeOffer {
  int price;
  String info;
  int requestId;
  String traderUid;
  Map traderLocation;

  TradeOffer({this.price, this.info, this.requestId});

  Future makeOffer() async {
    DocumentReference doc = Firestore.instance.collection('ProductRequests').document(this.requestId.toString());
    return await doc.get().then((onValue) async {
      if (onValue['available']) {
        await doc.updateData({
          'pendingTraders': FieldValue.arrayUnion([currentUser.uid]),
        });
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
        return false;
      } else {
        return true;
      }
    });
  }
}

Future<void> tradeOfferAccept(Map<String, dynamic> trade) async {
  String docId = trade['requestId'].toString();
  Firestore db = Firestore.instance;
  DocumentReference collection = db.collection('ProductRequests').document(docId);
  WriteBatch batch = db.batch();

  List<DocumentSnapshot> docs = (await collection.collection('offers').getDocuments()).documents;
  docs.forEach((d) => batch.delete(d.reference));
  DocumentSnapshot snapshot = (await collection.get());
  String sellerName = (await db.collection('Users').document(trade['traderUid']).get()).data['displayName'];
  Order order = new Order.fromRequest(snapshot.data, sellerName, trade);
  await order.placeNewOrder();
  batch.delete(snapshot.reference);
  await batch.commit();
}
