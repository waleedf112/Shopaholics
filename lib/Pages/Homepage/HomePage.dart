import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Pages/AddNewProduct/AddNewProduct.dart';
import 'package:shopaholics/Pages/AddProductRequest/AddProductRequest.dart';
import 'package:shopaholics/Pages/Settings/Settings.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/MainView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("الرئيسية"),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
        isTranslucent: false,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_basket),
        title: ("العربة"),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add_shopping_cart),
        title: ("الطلبات"),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: ("المفضلة"),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("الاعدادات"),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(

      controller: _controller,
      backgroundColor: Colors.white,
      items: _navBarsItems(),
      screens: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: 'heroProduct',
            onPressed: () => PagePush(context, AppNewProduct()),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            elevation: 0,
            disabledElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            backgroundColor: Colors.grey.withOpacity(0.7),
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              GridProducts(
                title: 'اجدد المنتجات',
                type: GridProductsType.offers,
              ),
              GridProducts(
                title: 'اخر العروض',
                type: GridProductsType.offers,
              ),
            ],
          ),
        ),
        Container(color: Colors.white, child: Placeholder()),
        Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: 'heroRequest',

            onPressed: () => PagePush(context, AddProductRequest()),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            elevation: 0,
            disabledElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            backgroundColor: Colors.grey.withOpacity(0.7),
          ),
          body: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              GridProducts(
                title: 'اجدد الطلبات',
                type: GridProductsType.requests,
              ),
            ],
          ),
        ),
        Container(color: Colors.white, child: Placeholder()),
        Container(color: Colors.white, child: SettingsPage()),
      ],

      showElevation: true,
      iconSize: 26.0,

      navBarStyle: NavBarStyle.style6,
      
    );
  }
}
