import 'package:flutter/material.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'عربة التسوق',
      child: ListView.builder(
        itemCount: 0,
        itemBuilder: (BuildContext context, int index) {
          return _CartItem();
        },
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: Border(),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: <Widget>[
            Text('sdfk'),
            FlutterLogo(
              size: 80,
            )
          ],
        ));
  }
}
