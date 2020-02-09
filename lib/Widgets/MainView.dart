import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Pages/AddProductRequest/AddProductRequest.dart';
import 'package:shopaholics/Pages/Settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class MainView extends StatefulWidget {
  Widget child;
  MainView({Key key, this.child = const SizedBox()}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  Widget Drawer() {
    return Material(
        child: SafeArea(
            //top: false,
            child: Container(
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(width: 1, color: Colors.grey[200]), right: BorderSide(width: 1, color: Colors.grey[200])),
      ),
      child: Stack(
        textDirection: TextDirection.rtl,
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 4, right: 18),
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircleAvatar(
                            child: Icon(Icons.person, color: Colors.white, size: 25),
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            "غير مسجل",
                            style: TextStyle(fontWeight: FontWeight.w600, height: 1.2),
                          ),
                        ),
                      ],
                    )),
                Divider(),
                ListTile(
                  title: Text("القسم الاول"),
                  leading: Icon(Icons.label_outline),
                ),
                ListTile(
                  title: Text("القسم الثاني"),
                  leading: Icon(Icons.label_outline),
                ),
                ListTile(
                  title: Text("القسم الثالث"),
                  leading: Icon(Icons.label_outline),
                ),
                ListTile(
                  title: Text("القسم الرابع"),
                  leading: Icon(Icons.label_outline),
                ),
                ListTile(
                  title: Text("القسم الخامس"),
                  leading: Icon(Icons.label_outline),
                ),
                ListTile(
                  title: Text("القسم السادس"),
                  leading: Icon(Icons.label_outline),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  //width: double.maxFinite,
                  decoration: BoxDecoration(
                      //color: Colors.grey,
                      border: Border(
                          top: BorderSide(
                    color: Colors.grey[300],
                  ))),
                  child: ListTile(
                    title: Text("اضافة طلب منتج"),
                    leading: Icon(Icons.add_comment),
                    onTap: () {
                      PagePush(context, AddProductRequest());
                      _innerDrawerKey.currentState.close();
                    },
                  ),
                ),
                ListTile(
                  title: Text("الاعدادات"),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    PagePush(context, SettingsPage());
                    _innerDrawerKey.currentState.close();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    )));
  }

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      tapScaffoldEnabled: false,
      leftOffset: 0,
      rightOffset: 0,
      swipe: true,
      boxShadow: [BoxShadow()],
      colorTransition: Colors.transparent,
      rightAnimationType: InnerDrawerAnimation.quadratic,
      rightChild: Drawer(),
      scaffold: Scaffold(
        appBar: AppBar(
          title: Text(
            currentUser == null ? 'مرحباً بك' : 'مرحباً بك يا ${currentUser.displayName}',
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              print(currentUser.displayName);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _innerDrawerKey.currentState.open(),
            ),
          ],
        ),
        body: widget.child,
      ),
    );
  }
}
