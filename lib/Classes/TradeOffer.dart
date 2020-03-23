import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class TradeOffer {
  int price;
  String info;
  int requestId;
  String traderUid;
  Map traderLocation;

  TradeOffer({this.price, this.info, this.requestId});

  Future makeOffer() async {
    DocumentReference doc = Firestore.instance
        .collection('ProductRequests')
        .document(this.requestId.toString());
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
  var db = Firestore.instance;
  var batch = db.batch();
  List<DocumentSnapshot> docs = (await Firestore.instance
          .collection('ProductRequests')
          .document(trade['requestId'].toString())
          .collection('offers')
          .getDocuments())
      .documents;
  docs.forEach((d) => batch.delete(d.reference));
  batch.updateData(
    db.collection('ProductRequests').document(trade['requestId'].toString()),
    {
      'pendingTraders': FieldValue.delete(),
      'acceptedTrader': trade['traderUid'],
      'available': false,
      'acceptedTrade': {
        'info': trade['info'],
        'price': trade['price'],
        'traderLocation': trade['traderLocation'],
      },
    },
  );

  await batch.commit();
}
