import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/rating.dart';

class ProductViewer extends StatefulWidget {
  var product;
  bool liked = false;

  ProductViewer({@required this.product});

  @override
  _ProductViewerState createState() => _ProductViewerState();
}

class _ProductViewerState extends State<ProductViewer> {
  bool liked = false;

  Widget likeButton() {
    if (widget.liked) {
      return IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 35,
          ),
          onPressed: () => setState(() => widget.liked = false));
    } else {
      return IconButton(
          icon: Icon(
            Icons.favorite_border,
            size: 35,
          ),
          onPressed: () => setState(() => widget.liked = true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: widget.product.productName,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Placeholder(
                    fallbackHeight: 250,
                    color: Colors.grey.withOpacity(0.0),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(widget.product.productName,
                                maxFontSize: 35, minFontSize: 30, style: TextStyle(fontWeight: FontWeight.bold)),
                            AutoSizeText(
                              widget.product.productDescription,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                      likeButton(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: TextWidget(
                        widget.product is ProductOffer
                            ? '${widget.product.productPrice} ريال'
                            : '${widget.product.productPrice} ريال كحد اقصى',
                        maxFontSize: 25,
                        minFontSize: 21,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Divider(color: Colors.black.withOpacity(0.5)),
                  TextWidget(widget.product is ProductOffer ? 'البائع' : 'الزبون',
                      maxFontSize: 25, minFontSize: 20, style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 17),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextWidget(widget.product.user, minFontSize: 16, maxFontSize: 18),
                                Rating(widget.product.userRating),
                              ],
                            ),
                          ),
                          OutlinedButton(text: 'ارسال رسالة'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      children: <Widget>[
                        OutlinedButton(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(widget.product is ProductOffer ? 'اضافة الى العربة' : 'تقديم عرض للزبون'),
                                ],
                              )),
                              Icon(widget.product is ProductOffer ? Icons.add_shopping_cart : Icons.local_offer),
                            ],
                          ),
                        )),
                        OutlinedButton(
                            child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(widget.product is ProductOffer ? 'تبليغ عن منتج مخالف' : 'تبليغ عن طلب مخالف'),
                                ],
                              )),
                              Icon(Icons.priority_high),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
