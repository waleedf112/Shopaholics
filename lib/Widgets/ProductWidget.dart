import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';
import 'package:shopaholics/Classes/Product.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Functions/time.dart';
import 'package:shopaholics/Pages/ProductViewer/ProductViewer.dart';

import 'TextWidget.dart';

class ProductWidget extends StatefulWidget {
  var item;
  bool liked = false;
  ProductWidget(@required this.item);

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
      return TextWidget('${widget.item.productPrice} ريال', style: TextStyle(fontWeight: FontWeight.bold));
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
                  child: widget.item.productImagesURLs.isEmpty
                      ? Placeholder()
                      : ImageFade(
                          image: NetworkImage(widget.item.productImagesURLs[0]),
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
                  child: widget.item.productImagesURLs.isEmpty
                      ? Placeholder()
                      : ImageFade(
                          image: NetworkImage(widget.item.productImagesURLs[0]),
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
