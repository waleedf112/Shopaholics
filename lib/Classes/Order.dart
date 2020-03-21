import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class Order {
  String number;
  int dateTime = DateTime.now().millisecondsSinceEpoch;
  List<Map<String, dynamic>> products = new List();
  int productsPrice = 0;
  int delivery = 25;

  Order(List<Map> products) {
    products.forEach((data) {
      this.products.add({
        'sellerUid': data['product']['User']['uid'],
        'sellerDisplayName': data['product']['User']['displayName'],
        'image': data['product']['productImagesURLs'][0],
        'productId': data['product']['id'],
        'productDescription': data['product']['productDescription'],
        'productName': data['product']['productName'],
        'productPrice': data['product']['productPrice'],
        'quantity': data['count'],
      });
      this.productsPrice += data['product']['productPrice'] * data['count'];
    });
  }

  Future<void> placeNewOrder() async {
    DocumentReference documentReference = Firestore.instance.collection('Counters').document('ordersID');
    await documentReference.get().then((counterValue) {
      this.number = counterValue.data['id'].toString();
    });
    await documentReference.updateData({
      'id': FieldValue.increment(1),
    });
    Map<String, dynamic> data = {
      'number': this.number,
      'dateTime': this.dateTime,
      'uid': currentUser.uid,
      'location': currentUser.location,
      'statusMessage': 'تم اضافة الطلب',
      'statusIconIndex': 0,
      'products': this.products,
      'productsPrice': this.productsPrice,
      'delivery': this.delivery,
    };
    await Firestore.instance.collection('Orders').document(this.number).setData(data);
    await currentUser.emptyCart();
  }
}
