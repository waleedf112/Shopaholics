import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Functions/PagePush.dart';

import 'Button.dart';
import 'CustomStreamBuilder.dart';
import 'ListProducts.dart';
import 'ProductWidget.dart';
import 'SecondaryView.dart';
import 'TextWidget.dart';

enum GridProductsType { requests, offers }
enum SortingProducts { byTime, byName, byPrice }

class GridProducts extends StatefulWidget {
  GridProductsType type;
  SortingProducts sortingProducts;
  String title;

  GridProducts({this.type, this.title, this.sortingProducts});

  @override
  _GridProductsState createState() => _GridProductsState();
}

class _GridProductsState extends State<GridProducts> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case GridProductsType.requests:
        CollectionReference collection =
            Firestore.instance.collection('ProductRequests');
        Query query = collection;
        if (!isSignedIn() || currentUser.role == UserRole.customer) {
          query = collection.where('uid',
              isEqualTo: isSignedIn() ? currentUser.uid : '');
        } else if (currentUser.role == UserRole.personalShopper) {
          query = collection.where('available', isEqualTo: true);
        }

        return StreamBuilder(
          stream: query.getDocuments().asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            List<DocumentSnapshot> documents;
            try {
              documents = snapshot.data.documents;
              documents.sort((DocumentSnapshot k, DocumentSnapshot i) {
                k.data['Time'].compareTo(i.data['Time']);
              });
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
                              function: () {
                                PagePush(
                                  context,
                                  SecondaryView(
                                    title: widget.title,
                                    child: ListProducts(
                                      list: documents,
                                      gridProductsType:
                                          GridProductsType.requests,
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    Container(
                      height: 350,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: documents == null
                            ? 0
                            : documents.length > 10 ? 10 : documents.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          ProductRequest _product =
                              new ProductRequest.retrieveFromDatabase(
                            documents[index].data,
                            documents[index].reference.path,
                          );
                          return ProductWidget(
                            item: _product,
                            liked: false,
                          );
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
          stream: Firestore.instance
              .collection('ProductOffer')
              .getDocuments()
              .asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            List<DocumentSnapshot> documents;
            try {
              documents = snapshot.data.documents;
              switch (widget.sortingProducts) {
                case SortingProducts.byName:
                  documents.sort((DocumentSnapshot k, DocumentSnapshot i) =>
                      i.data['productName'].compareTo(k.data['productName']));
                  break;
                case SortingProducts.byPrice:
                  documents.sort((DocumentSnapshot k, DocumentSnapshot i) =>
                      k.data['productPrice'].compareTo(i.data['productPrice']));
                  break;
                case SortingProducts.byTime:
                  documents.sort((DocumentSnapshot k, DocumentSnapshot i) =>
                      i.data['Time'].compareTo(k.data['Time']));
                  break;
                default:
                  break;
              }
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
                              function: () {
                                PagePush(
                                  context,
                                  SecondaryView(
                                    title: widget.title,
                                    child: ListProducts(
                                      list: documents,
                                      gridProductsType: GridProductsType.offers,
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    Container(
                      height: 350,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: documents == null
                            ? 0
                            : documents.length > 10 ? 10 : documents.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          ProductOffer _product =
                              new ProductOffer.retrieveFromDatabase(
                            documents[index].data,
                            documents[index].reference.path,
                          );
                          if (!isSignedIn() ||
                              currentUser.likedOffers == null ||
                              currentUser.likedOffers.isEmpty)
                            return ProductWidget(
                              item: _product,
                              liked: false,
                            );

                          String ref =
                              documents[index].reference.path.split('/')[1];
                          int id = int.parse(ref);
                          return ProductWidget(
                            item: _product,
                            liked: currentUser.likedOffers.contains(id),
                          );
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
