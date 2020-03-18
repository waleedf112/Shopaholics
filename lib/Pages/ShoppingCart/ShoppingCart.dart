import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

import 'noProductsInCart.dart';

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'العربة',
      child: FutureBuilder(
        future: currentUser.getCart(),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _CartItem(
                    new ProductOffer.retrieveFromDatabase(
                      snapshot.data[index]['product'],
                      snapshot.data[index]['product']['id'].toString(),
                    ),
                    snapshot.data[index]['count']);
              },
            );
          }

          return SpinKitHourGlass(color: Colors.grey.withOpacity(0.4));
        },
      ),
    );
  }
}

class _CartItem extends StatefulWidget {
  ProductOffer product;
  int quantity;
  _CartItem(this.product, this.quantity);

  @override
  __CartItemState createState() => __CartItemState();
}

class __CartItemState extends State<_CartItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: Border(),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(widget.product.productName),
                      SizedBox(height: 5),
                      TextWidget('#' + widget.product.reference, style: TextStyle(color: Colors.grey, fontSize: 11)),
                      SizedBox(height: 3),
                      TextWidget('${widget.product.productPrice} ريال', style: TextStyle(color: Colors.red[700])),
                    ],
                  ),
                )),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    onPressed: () {
                      if (widget.quantity < 100)
                        setState(() {
                          widget.quantity++;
                        });
                    },
                  ),
                  Text(
                    widget.quantity.toString(),
                    style: TextStyle(fontSize: 19),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    onPressed: () {
                      if (widget.quantity > 1)
                        setState(() {
                          widget.quantity--;
                        });
                      else
                        CustomDialog(
                            context: context,
                            title: 'حذف المنتج',
                            content: Text(
                              'هل انت متأكد انك تريد حذف هذا المنتج من العربة؟',
                              textAlign: TextAlign.center,
                            ),
                            firstButtonColor: Colors.red,
                            firstButtonText: 'حذف المنتج',
                            secondButtonText: 'الغاء',
                            secondButtonColor: Colors.black54,
                            firstButtonFunction: () {},
                            secondButtonFunction: () {
                              Navigator.of(context).pop();
                            });
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: ImageFade(
                height: 120,
                image: NetworkImage(widget.product.productImagesURLs[0]),
                errorBuilder: (BuildContext context, Widget child, dynamic exception) {
                  return Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 128.0)),
                  );
                },
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent event) {
                  return Container(
                    color: Colors.grey.withOpacity(0.2),
                    child: SpinKitDoubleBounce(
                      color: Colors.white,
                    ),
                  );
                },
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
