import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';

import 'CustomStreamBuilder.dart';
import 'ProductWidget.dart';
import 'TextWidget.dart';

enum GridProductsType { requests, offers, mock }

class GridProducts extends StatelessWidget {
  List<Product> items;
  GridProductsType type;
  GridProducts({
    this.items = const [],
    this.type = GridProductsType.mock,
  });
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case GridProductsType.mock:
        return GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: Border(),
              margin: EdgeInsets.all(0),
              elevation: 2,
              child: ProductWidget(items[index]),
            );
          },
        );
        break;
      case GridProductsType.requests:
        return StreamBuilder(
          stream: Firestore.instance.collection('ProductRequests').getDocuments().asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            List<DocumentSnapshot> documents;
            try {
              documents = snapshot.data.documents;
            } catch (e) {}
            return LoadingStreamBuilder(
              hasData: snapshot.hasData,
              loading: documents == null,
              widget: GridView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: documents == null ? 0 : documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  ProductRequest _product = new ProductRequest.retrieveFromDatabase(documents[index].data);
                  return Card(
                    shape: Border(),
                    margin: EdgeInsets.all(0),
                    elevation: 2,
                    child: ProductWidget(_product),
                  );
                },
              ),
            );
          },
        );
        break;
      case GridProductsType.offers:
        break;
    }
  }
}
