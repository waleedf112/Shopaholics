import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Pages/FavoritePage/noFavoriteProducts.dart';

import 'GridProducts.dart';
import 'ProductWidget.dart';

class ListProducts extends StatefulWidget {
  List<DocumentSnapshot> list;

  ListProducts({@required this.list});

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.5),
          itemBuilder: (BuildContext context, int index) {
            ProductOffer _product = new ProductOffer.retrieveFromDatabase(
              widget.list[index].data,
              widget.list[index].reference.path.toString(),
            );
            String ref = widget.list[index].reference.path.split('/')[1];
            int id = int.parse(ref);
            return ProductWidget(_product, currentUser.likedOffers.contains(id));
          },
        ),
      ),
    );
  }
}
