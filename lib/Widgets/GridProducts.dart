import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';

import 'Button.dart';
import 'CustomStreamBuilder.dart';
import 'ProductWidget.dart';
import 'TextWidget.dart';

enum GridProductsType { requests, offers, mock }

class GridProducts extends StatelessWidget {
  List<Product> items;
  GridProductsType type;
  String title;
  GridProducts({
    this.items = const [],
    this.type = GridProductsType.mock,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case GridProductsType.mock:
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextWidget(
                      title,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OutlinedButton(
                      text: 'عرض الكل',
                    ),
                  ],
                ),
              ),
              Container(
                height: 350,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: items.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    int getIndex() => index % 7;

                    return ProductWidget(items[index], 'assets/images/mock_product${getIndex()}.jpg');
                  },
                ),
              ),
            ],
          ),
        );
        break;
      case GridProductsType.requests:
        return Container(
          height: 300,
          child: StreamBuilder(
            stream: Firestore.instance.collection('ProductRequests').getDocuments().asStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<DocumentSnapshot> documents;
              try {
                documents = snapshot.data.documents;
              } catch (e) {}
              return LoadingStreamBuilder(
                hasData: snapshot.hasData,
                loading: documents == null,
                widget: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: documents == null ? 0 : documents.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      int getIndex() => index % 7;
                      ProductRequest _product = new ProductRequest.retrieveFromDatabase(documents[index].data);
                      return ProductWidget(_product, 'assets/images/mock_product${getIndex()}.jpg');
                    },
                  ),
                ),
              );
            },
          ),
        );
        break;
      case GridProductsType.offers:
        break;
    }
  }
}
