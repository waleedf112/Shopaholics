import 'package:auto_size_text/auto_size_text.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/MainView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  List<Product> mockProducts = new List();
  @override
  Widget build(BuildContext context) {
    mockProducts = new List();
    for (int i = 1; i <= 11; i++) {
      mockProducts.add(new Product(productName: 'منتج تجريبي'));
      mockProducts.last.setPrice(i * 10);
      if (i == 2 || i == 3 || i == 6 || i == 8) mockProducts.last.setDiscount(i * 10);
    }
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
          children: [
            Container(
              color: Colors.grey[50],
              child: GridProducts(
                type: GridProductsType.mock,
                items: mockProducts,
              ),
            ),
            Container(
              color: Colors.grey[50],
              child: GridProducts(
                type: GridProductsType.requests,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
