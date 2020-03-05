import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';

import 'Button.dart';
import 'CustomStreamBuilder.dart';
import 'ProductWidget.dart';
import 'TextWidget.dart';

enum GridProductsType { requests, offers }

class GridProducts extends StatefulWidget {
  GridProductsType type;
  String title;
  GridProducts({
    this.type,
    this.title,
  });

  @override
  _GridProductsState createState() => _GridProductsState();
}

class _GridProductsState extends State<GridProducts> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
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
              widget: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            widget.title,
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
                        itemCount: documents == null ? 0 : documents.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          ProductRequest _product = new ProductRequest.retrieveFromDatabase(
                            documents[index].data,
                            documents[index].reference.path,
                          );
                          return ProductWidget(_product);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        break;
      case GridProductsType.offers:
        return StreamBuilder(
          stream: Firestore.instance.collection('ProductOffer').getDocuments().asStream(),
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
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            widget.title,
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
                        itemCount: documents == null ? 0 : documents.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          ProductOffer _product = new ProductOffer.retrieveFromDatabase(
                            documents[index].data,
                            documents[index].reference.path,
                          );
                          return ProductWidget(_product);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
        break;
    }
  }
}
