import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

import 'noProductsInCart.dart';

class ShoppingCart extends StatefulWidget {
  int productsPrice = 0;
  int delivery = 25;
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser.getCart().then((onValue) {
      widget.productsPrice = 0;
      for (int i = 0; i < onValue.length; i++) {
        widget.productsPrice += onValue[i]['product']['productPrice'] * onValue[i]['count'];
      }
      setState(() {
        print('object');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'العربة',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FutureBuilder(
            future: currentUser.getCart(),
            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    ProductOffer product = new ProductOffer.retrieveFromDatabase(
                      snapshot.data[index]['product'],
                      snapshot.data[index]['product']['id'].toString(),
                    );
                    int quantity = snapshot.data[index]['count'];
                    widget.productsPrice += product.productPrice * quantity;

                    return quantity == 0
                        ? Container()
                        : Card(
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
                                            TextWidget(product.productName),
                                            SizedBox(height: 5),
                                            TextWidget('#' + product.reference,
                                                style: TextStyle(color: Colors.grey, fontSize: 11)),
                                            SizedBox(height: 3),
                                            TextWidget('${product.productPrice} ريال',
                                                style: TextStyle(color: Colors.red[700])),
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
                                            if (quantity < 100)
                                              setState(() {
                                                quantity++;
                                                widget.productsPrice+=product.productPrice;
                                                currentUser.modifyItemInCart(
                                                    quantity: quantity, ref: product.reference);
                                              });
                                          },
                                        ),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(fontSize: 19),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.grey.withOpacity(0.5),
                                          ),
                                          onPressed: () {
                                            if (quantity > 1)
                                              setState(() {
                                                quantity--;
                                                widget.productsPrice-=product.productPrice;

                                                currentUser.modifyItemInCart(
                                                    quantity: quantity, ref: product.reference);
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
                                                  firstButtonFunction: () {
                                                    quantity--;

                                                    currentUser.modifyItemInCart(
                                                        quantity: quantity, ref: product.reference);
                                                    Navigator.of(context).pop();
                                                    setState(() {});
                                                  },
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
                                      image: NetworkImage(product.productImagesURLs[0]),
                                      errorBuilder: (BuildContext context, Widget child, dynamic exception) {
                                        return Container(
                                          color: Colors.grey.withOpacity(0.2),
                                          child:
                                              Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 128.0)),
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
                  },
                );
              }

              return SpinKitHourGlass(color: Colors.grey.withOpacity(0.4));
            },
          ),
          Column(
            children: <Widget>[
              Divider(color: Colors.black38),
              Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _infoRow(title: 'السلع', value: widget.productsPrice),
                        _infoRow(title: 'التوصيل', value: 0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _infoRow(title: 'المجموع', value: 5, isBold: true),
                      ],
                    ),
                  ),
                ],
              ),
              SimpleButton(
                'تأكيد الطلب',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

_infoRow({String title, int value, bool isBold = false}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(title + ' :', style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : null)),
            Expanded(child: Row()),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                value.toString() + ' ريال',
                style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
              ),
            ),
          ],
        ),
      ),
    );
