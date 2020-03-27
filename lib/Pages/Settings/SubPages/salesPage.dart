import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/Order.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'المبيعات',
      child: FutureBuilder(
        future: Firestore.instance.collection('Orders').getDocuments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Order> list = new List();
          snapshot.data.documents.forEach((doc) => list.add(new Order.fromDatabase(doc)));
          /* list.removeWhere((test){
            if(test.data.)
          }); */
          if (snapshot.hasData && list.isNotEmpty)
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Column(
                    children: <Widget>[
                      Text(list[index].number.toString()),
                      Text(list[index].dateTime.toString()),
                      Text(list[index].productsPrice.toString()),
                      Text(list[index].delivery.toString()),
                      Text(list[index].products.length.toString()),
                    ],
                  ),
                );
              },
            );
          if (list.isEmpty) return Container();
          return SpinKitRotatingCircle(
            color: Colors.grey.withOpacity(0.3),
          );
        },
      ),
    );
  }
}
