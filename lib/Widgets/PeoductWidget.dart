import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';

import 'TextWidget.dart';

class ProductWidget extends StatelessWidget {
  String imagePath = 'assets/images/mock_product.jpg';
  Product item;
  ProductWidget(@required this.item);
  @override
  Widget build(BuildContext context) {
    Widget getPrice() {
      if (item.hasDiscount())
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextWidget(
              '${item.getOldPrice()} ريال',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                decoration: TextDecoration.lineThrough,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 5),
            TextWidget(
              '${item.getPrice()} ريال',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      return TextWidget('${item.getPrice()} ريال');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(imagePath),
        ),
        Divider(height: 0),
        TextWidget(item.productName),
        getPrice(),
      ],
    );
  }
}
