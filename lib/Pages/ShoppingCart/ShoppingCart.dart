import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

import 'noProductsInCart.dart';

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'العربة',
      child: FutureBuilder(
        future: currentUser.getCart(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _CartItem(new ProductOffer.retrieveFromDatabase(
                    snapshot.data[index]['product'], snapshot.data[index]['product']['id'].toString()));
              },
            );
          }

          return SpinKitHourGlass(color: Colors.grey.withOpacity(0.4));
        },
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  ProductOffer product;
  _CartItem(this.product);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: Border(),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: <Widget>[
              Expanded(child: TextWidget(product.productName)),
              Expanded(child: TextWidget(product.reference)),
              FlutterLogo(
                size: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
