import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

import '../Functions/PagePush.dart';
import '../Functions/Translation.dart';
import '../Pages/ShoppingCart/ShoppingCart.dart';
import 'GridProducts.dart';
import 'ListProducts.dart';
import 'dismissKeyboard.dart';
import 'noSearchResult.dart';

class MainView extends StatelessWidget {
  Widget child;
  MainView({this.child = const SizedBox()});
  static final ValueNotifier<String> searchText = ValueNotifier<String>(null);
  static final TextEditingController searchController = new TextEditingController();
  static final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: <Widget>[
                    ValueListenableBuilder(
                      valueListenable: searchText,
                      builder: (BuildContext context, String value, Widget child) {
                        if (value != null && value.trim().isNotEmpty)
                          return IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              searchController.text = '';
                              searchText.value = null;
                            },
                          );
                        else
                          return IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          );
                      },
                    ),
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: searchController,
                          onChanged: (String s) {
                            if (s.trim().isEmpty)
                              searchText.value = null;
                            else
                              searchText.value = s;
                          },
                          decoration: InputDecoration(
                            hintText: textTranslation(ar: 'البحث عن منتج', en: 'Search For Products'),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Mdi.cartOutline),
                        onPressed: () {
                          PagePush(context, ShoppingCart());
                        }),
                  ],
                ),
              ),
              Divider(color: Colors.black38),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: searchText,
                  builder: (BuildContext context, String value, Widget childW) {
                    if (value != null && value.trim().isNotEmpty) {
                      return StreamBuilder(
                        stream: Firestore.instance
                            .collection('ProductOffer')
                            .where('deleted', isEqualTo: false)
                            .where('tags', arrayContainsAny: searchText.value.split(' '))
                            .getDocuments()
                            .asStream(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData && snapshot.data.documents.isNotEmpty) {
                            return ListProducts(
                              list: snapshot.data.documents,
                              gridProductsType: GridProductsType.offers,
                            );
                          } else
                            return NoSearchResult();
                        },
                      );
                    } else {
                      return child;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
