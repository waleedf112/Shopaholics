import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_fade/image_fade.dart';
import 'package:mdi/mdi.dart';

import '../Classes/Product.dart';
import '../Classes/User.dart';
import '../Functions/PagePush.dart';
import '../Functions/Translation.dart';
import '../Functions/distanceCalculator.dart';
import '../Functions/time.dart';
import '../Pages/ProductViewer/ProductViewer.dart';
import '../Pages/RequestsPage/RequestsPage.dart';
import 'TextWidget.dart';

class ProductWidget extends StatefulWidget {
  var item;
  bool liked;
  bool isMyRequest;
  RequestType requestType;
  ProductWidget({
    @required this.item,
    this.liked,
    this.isMyRequest = false,
    this.requestType,
  });

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Widget likeButton() {
      if (widget.liked != null && widget.item.userUid == currentUser.uid)
        return IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.transparent,
          ),
          onPressed: null,
        );
      if (widget.liked) {
        return IconButton(
            icon: Icon(
              widget.item is ProductRequest ? Icons.bookmark : Icons.favorite,
              color: widget.item is ProductRequest ? Colors.green[600] : Colors.red,
            ),
            onPressed: widget.item is ProductRequest
                ? null
                : () => setState(() {
                      widget.liked = false;
                      widget.item.removeFromLikes();
                    }));
      } else {
        return IconButton(
            icon: Icon(
              widget.item is ProductRequest ? Icons.bookmark_border : Icons.favorite_border,
            ),
            onPressed: widget.item is ProductRequest
                ? null
                : () => setState(() {
                      if (isSignedIn()) {
                        widget.liked = true;
                        widget.item.addToLikes();
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            textTranslation(ar: "الرجاء تسجيل دخولك لتتمكن من الاضافة الى المفضلة", en: 'Please sign in before adding prodects to your favorite'),
                            textDirection: TextDirection.rtl,
                          ),
                        ));
                      }
                    }));
      }
    }

    infoText() {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.only(top: 3, right: 7),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextWidget(formatTime(widget.item.time), style: TextStyle(color: Colors.grey, fontSize: 11)),
                      TextWidget(widget.item.productName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          maxFontSize: 14,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis),
                      TextWidget(widget.item.user),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget getPrice() {
      return TextWidget('${widget.item.productPrice} ${textTranslation(ar: 'ريال', en: 'SR')}',
          style: TextStyle(fontWeight: FontWeight.bold));
    }

    if (widget.item is ProductRequest) {
      return InkWell(
        onTap: () => PagePush(
            context,
            ProductViewer(
              product: widget.item,
              isMyRequest: widget.isMyRequest,
              requestType: widget.requestType,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      getPrice(),
                      FutureBuilder(
                        future: calculateDistance(widget.item.userUid),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasError) {
                            return Icon(
                              Mdi.mapMarkerRemoveOutline,
                              color: Colors.grey,
                              size: 18,
                            );
                          } else if (snapshot.hasData) {
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextWidget(snapshot.data,
                                  minFontSize: 11,
                                  maxFontSize: 14,
                                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SpinKitHourGlass(
                              color: Colors.grey.withOpacity(0.5),
                              size: 18,
                            ),
                          );
                        },
                      ),
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
        onTap: () => PagePush(context, ProductViewer(product: widget.item, requestType: widget.requestType)),
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
                          fit: BoxFit.fitHeight,
                          width: 200,
                        ),
                ),
                infoText(),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: TextDirection.rtl,
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
