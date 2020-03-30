import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class MyProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'منتجاتي',
      child: StreamBuilder(
        stream: Firestore.instance.collection('ProductOffer').getDocuments().asStream() ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Container(
          );
        },
      ),
    );
  }
}
