import 'dart:async';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Pages/AddProductRequest/AddProductRequest.dart';
import 'package:shopaholics/Pages/AddNewProduct/AddNewProduct.dart';
import 'package:shopaholics/Pages/Settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Pages/ShoppingCart/ShoppingCart.dart';
import 'CustomErrorDialog.dart';
import 'dismissKeyboard.dart';

class MainView extends StatefulWidget {
  Widget child;
  MainView({Key key, this.child = const SizedBox()}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: WillPopScope(
        onWillPop: () {},
        child: Scaffold(
          appBar: AppBar(
              title: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.search), onPressed: () {}),
                Expanded(
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: 'البحث عن منتج',
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
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
          )),
          body: widget.child,
        ),
      ),
    );
  }
}
