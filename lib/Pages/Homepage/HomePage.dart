import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-bottom-nav-bar-styles.widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Pages/AddNewProduct/AddNewProduct.dart';
import 'package:shopaholics/Pages/AddProductRequest/AddProductRequest.dart';
import 'package:shopaholics/Pages/FavoritePage/FavoritePage.dart';
import 'package:shopaholics/Pages/RequestsPage/RequestsPage.dart';
import 'package:shopaholics/Pages/Settings/Settings.dart';
import 'package:shopaholics/Pages/ShoppingCart/ShoppingCart.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/ListProducts.dart';
import 'package:shopaholics/Widgets/MainView.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

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
      showElevation: false,
      navBarHeight: Platform.isIOS ? 75 : 60,
      iconSize: 23.0,
      bottomPadding: 5,
      navBarStyle: NavBarStyle.style6,
      items: _navBarsItems(),
      screens: [
        Scaffold(
          floatingActionButton:
              isSignedIn() && currentUser.role != UserRole.customer
                  ? FloatingActionButton(
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
                    )
                  : null,
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: false,
                  children: <Widget>[
                    GridProducts(
                      title: 'اجدد المنتجات',
                      type: GridProductsType.offers,
                      sortingProducts: SortingProducts.byTime,
                    ),
                    GridProducts(
                      title: 'اخر العروض',
                      type: GridProductsType.offers,
                      sortingProducts: SortingProducts.byPrice,
                    ),
                  ],
                ),
              ),
              Divider(height: 0, color: Colors.black38),
            ],
          ),
        ),
        Scaffold(
          floatingActionButton: isSignedIn()
              ? FloatingActionButton(
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
                )
              : null,
          body: Column(
            children: <Widget>[
              Expanded(child: RequestsPage()),
              Divider(height: 0, color: Colors.black38),
            ],
          ),
        ),
        Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(child: FavoritePage()),
              Divider(height: 0, color: Colors.black38),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            Expanded(
                child: Container(color: Colors.white, child: SettingsPage())),
            Divider(height: 0, color: Colors.black38),
          ],
        ),
      ],
    );
  }
}
