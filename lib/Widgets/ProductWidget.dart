import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Functions/time.dart';
import 'package:shopaholics/Pages/ProductViewer/ProductViewer.dart';

import 'TextWidget.dart';

class ProductWidget extends StatefulWidget {
  String imagePath;
  var item;
  bool liked = false;
  ProductWidget(@required this.item, [this.imagePath]);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Widget likeButton() {
      if (widget.liked) {
        return IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () => setState(() => widget.liked = false));
      } else {
        return IconButton(icon: Icon(Icons.favorite_border), onPressed: () => setState(() => widget.liked = true));
      }
    }

    infoText() {
      return Padding(
        padding: const EdgeInsets.only(top: 3, right: 7),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextWidget(formatTime(widget.item.time), style: TextStyle(color: Colors.grey, fontSize: 11)),
                TextWidget(widget.item.productName, style: TextStyle(fontWeight: FontWeight.bold)),
                TextWidget(widget.item.user),
              ],
            ),
          ],
        ),
      );
    }

    Widget getPrice() {
      return TextWidget('${widget.item.productPrice} ريال');
    }

    if (widget.item is ProductRequest) {
      return InkWell(
        onTap: () => PagePush(
            context,
            ProductViewer(
              product: widget.item,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: widget.imagePath == null
                      ? Placeholder()
                      : Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          width: 200,
                        ),
                ),
                infoText(),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getPrice(),
                      likeButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.item is ProductOffer) {
      return InkWell(
        onTap: () => PagePush(
            context,
            ProductViewer(
              product: widget.item,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: widget.imagePath == null
                      ? Placeholder()
                      : Image.asset(
                          widget.imagePath,
                          fit: BoxFit.cover,
                          width: 200,
                        ),
                ),
                infoText(),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      getPrice(),
                      likeButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
