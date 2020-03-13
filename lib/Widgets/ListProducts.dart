import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Pages/FavoritePage/noFavoriteProducts.dart';

class ListProducts extends StatefulWidget {
  List<DocumentSnapshot> list;

  ListProducts({@required this.list});

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          ProductOffer item = new ProductOffer.retrieveFromDatabase(
            widget.list[index].data,
            widget.list[index].reference.path.toString(),
          );
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(item.productName),
              ),
              Divider(
                color: Colors.black.withOpacity(0.7),
              )
            ],
          );
        },
      ),
    );
  }
}
