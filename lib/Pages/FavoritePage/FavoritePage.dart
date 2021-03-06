import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/ListProducts.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

import 'noFavoriteProducts.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isSignedIn()) {
      return StreamBuilder(
        stream: currentUser.getLikedOffers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.length == 0) {
            return NoFavoriteProducts();
          } else {
            return ListProducts(
              list: snapshot.data.documents,
              gridProductsType: GridProductsType.offers,
            );
          }
        },
      );
    } else {
      return NoFavoriteProducts();
    }
  }
}
