import 'package:auto_size_text/auto_size_text.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/MainView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return DefaultTabController(

      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TabBar(
          tabs: [
            Tab(text: 'المنتجات'),
            Tab(text: 'الطلبات'),
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ListView(
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
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                GridProducts(
                  title: 'اخر العروض',

                  type: GridProductsType.requests,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
