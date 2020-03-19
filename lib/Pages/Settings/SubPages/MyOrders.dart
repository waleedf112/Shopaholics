import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'طلباتي',
      child: FutureBuilder(
        future: Firestore.instance.collection('Orders').where('uid', isEqualTo: currentUser.uid).getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.isEmpty)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[NoOrders()],
              );
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return _Order(snapshot.data.documents[index].data);
              },
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitHourGlass(color: Colors.grey.withOpacity(0.4)),
            ],
          );
        },
      ),
    );
  }
}

class _Order extends StatelessWidget {
  Map data;
  _Order(this.data);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['dateTime']);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      shape: Border(),
      elevation: 3,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(data['number'].toString()),
              Column(
                children: <Widget>[
                  Text(
                    'الطلب رقم #${data['number']}',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    '${date.year}/${date.month}/${date.day}',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '${data['productsPrice'] + data['delivery']}',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

NoOrders() => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Mdi.cartRemove,
            color: Colors.grey.withOpacity(0.6),
            size: 100,
          ),
          TextWidget('لاتوجد أي طلبات',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ))
        ],
      ),
    );
