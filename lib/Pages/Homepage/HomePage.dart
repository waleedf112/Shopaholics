import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Widgets/GridProducts.dart';
import 'package:shopaholics/Widgets/MainView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  List<Product> mockProducts = new List();

  @override
  Widget build(BuildContext context) {
    mockProducts = new List();
    print('adding ...');
    for (int i = 1; i <= 11; i++) {
      mockProducts.add(new Product(productName: 'منتج تجريبي'));
      mockProducts.last.setPrice(i * 10);
      if (i == 2 || i == 3 || i == 6 || i == 8)
        mockProducts.last.setDiscount(i * 10);
    }
    return GridProducts(
      items: mockProducts,
    );
  }
}
