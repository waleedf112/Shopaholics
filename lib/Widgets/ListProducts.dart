import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/Translation.dart';

import '../Classes/Product.dart';
import '../Classes/User.dart';
import '../Pages/RequestsPage/RequestsPage.dart';
import 'GridProducts.dart';
import 'ProductWidget.dart';

class ListProducts extends StatefulWidget {
  List<DocumentSnapshot> list;
  GridProductsType gridProductsType;
  RequestType requestType;
  ListProducts({@required this.list, @required this.gridProductsType, this.requestType});

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Directionality(
textDirection: layoutTranslation(),        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.5),
          itemBuilder: (BuildContext context, int index) {
            if (widget.gridProductsType == GridProductsType.offers) {
              ProductOffer _product = new ProductOffer.retrieveFromDatabase(
                widget.list[index].data,
                widget.list[index].reference.path.toString(),
              );
              String ref = widget.list[index].reference.path.split('/')[1];
              int id = int.parse(ref);
              try {
                return ProductWidget(
                  item: _product,
                  liked: currentUser.likedOffers.contains(id),
                  requestType: widget.requestType,
                );
              } catch (e) {
                return ProductWidget(
                  item: _product,
                  liked: false,
                  requestType: widget.requestType,
                );
              }
            } else {
              ProductRequest _product = new ProductRequest.retrieveFromDatabase(
                widget.list[index].data,
                widget.list[index].reference.path.toString(),
              );
              return ProductWidget(
                item: _product,
                requestType: widget.requestType,
              );
            }
          },
        ),
      ),
    );
  }
}
