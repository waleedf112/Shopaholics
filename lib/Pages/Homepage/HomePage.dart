import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:persistent_bottom_nav_bar/models/persistent-bottom-nav-bar-styles.widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../Classes/User.dart';
import '../../Classes/UserRole.dart';
import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Categories/CategoriesWidget.dart';
import '../../Widgets/GridProducts.dart';
import '../../main.dart';
import '../AddNewProduct/AddNewProduct.dart';
import '../AddProductRequest/AddProductRequest.dart';
import '../ChatsPage/ChatPage.dart';
import '../FavoritePage/FavoritePage.dart';
import '../RequestsPage/RequestsPage.dart';
import '../Settings/Settings.dart';

ValueNotifier<int> updatedHomePage = new ValueNotifier<int>(DateTime.now().millisecondsSinceEpoch);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    pushNotificationsManager.init();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: textTranslation(ar: 'الرئيسية', en: 'Home'),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add_shopping_cart),
        title: textTranslation(ar: 'الطلبات', en: 'Requests'),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: textTranslation(ar: 'المفضلة', en: 'Favorite'),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Mdi.chatOutline),
        title: textTranslation(ar: 'المحادثات', en: 'Chats'),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: textTranslation(ar: 'الاعدادات', en: 'Settings'),
        activeColor: Colors.black,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn()) currentUser.setToken();
    return PersistentTabView(
      controller: _controller,
      backgroundColor: Colors.white,
      showElevation: false,
      navBarHeight: Platform.isIOS ? 75 : 60,
      iconSize: 23.0,
      bottomPadding: 5,
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (i) {
        updatedHomePage.value = DateTime.now().millisecondsSinceEpoch;
        updatedChatPage.value = DateTime.now().millisecondsSinceEpoch;
      },
      items: _navBarsItems(),
      screens: [
        ValueListenableBuilder(
          valueListenable: updatedHomePage,
          builder: (BuildContext context, dynamic value, Widget child) {
            return Scaffold(
              floatingActionButton: isSignedIn() && currentUser.role != UserRole.customer
                  ? FloatingActionButton(
                      heroTag: 'heroProduct',
                      onPressed: () async {
                        mainCategoryNotifier.value = null;
                        subCategoriesNotifier.value = null;
                        PagePush(context, AppNewProduct());
                      },
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
                          title: textTranslation(ar: 'اجدد المنتجات', en: 'New Products'),
                          type: GridProductsType.offers,
                          sortingProducts: SortingProducts.byTime,
                        ),
                        GridProducts(
                          title: textTranslation(ar: 'اخر العروض', en: 'Latest Offers'),
                          type: GridProductsType.offers,
                          sortingProducts: SortingProducts.byPrice,
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, color: Colors.black38),
                ],
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: updatedHomePage,
          builder: (BuildContext context, dynamic value, Widget child) {
            return Scaffold(
              floatingActionButton: isSignedIn()
                  ? FloatingActionButton(
                      heroTag: 'heroRequest',
                      onPressed: () async {
                        PagePush(context, AddProductRequest());
                      },
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
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: updatedHomePage,
          builder: (BuildContext context, dynamic value, Widget child) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Expanded(child: FavoritePage()),
                  Divider(height: 0, color: Colors.black38),
                ],
              ),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: updatedChatPage,
          builder: (BuildContext context, dynamic value, Widget child) {
            return ChatPage();
          },
        ),
        Column(
          children: <Widget>[
            Expanded(child: Container(color: Colors.white, child: SettingsPage())),
            Divider(height: 0, color: Colors.black38),
          ],
        ),
      ],
    );
  }
}
