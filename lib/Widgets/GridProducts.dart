import 'package:auto_size_text/auto_size_text.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';

import 'PeoductWidget.dart';
import 'TextWidget.dart';

class GridProducts extends StatelessWidget {
  List<Product> items;
  GridProducts({this.items = const []});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shape: Border(),
          margin: EdgeInsets.all(0),
          elevation: 2,
          child: ProductWidget(items[index]),
        );
      },
    );
  }
}
