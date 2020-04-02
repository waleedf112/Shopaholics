import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_fade/image_fade.dart';
import 'package:mdi/mdi.dart';
import 'package:shopaholics/Functions/AppLanguage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Classes/Product.dart';
import '../../Classes/User.dart';
import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Functions/distanceCalculator.dart';
import '../../Functions/openMap.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/Categories/CategoriesText.dart';
import '../../Widgets/Categories/CategoryChip.dart';
import '../../Widgets/CustomDialog.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/TextWidget.dart';
import '../../Widgets/loadingDialog.dart';
import '../../Widgets/rating.dart';
import '../ChatsPage/ChatPage.dart';
import '../RequestsPage/OfferRow.dart';
import '../RequestsPage/RequestsPage.dart';
import '../Settings/SubPages/MyProducts.dart';
import '../TicketsPages/TicketPage.dart';
import 'EditProduct.dart';
import 'MakeOffer.dart';

class ProductViewer extends StatefulWidget {
  var product;
  bool liked = false;
  bool isMyRequest;
  RequestType requestType;
  ProductViewer({@required this.product, this.isMyRequest = false, this.requestType});

  @override
  _ProductViewerState createState() => _ProductViewerState();
}

class _ProductViewerState extends State<ProductViewer> {
  @override
  void initState() {
    super.initState();
    widget.liked = widget.product.isLiked();
  }

  Widget likeButton() {
    if (widget.liked != null && widget.product.userUid == currentUser.uid)
      return Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Mdi.fileDocumentEdit,
              color: Colors.grey.withOpacity(0.7),
            ),
            onPressed: () => PagePush(context, EditProduct(widget.product)),
          ),
          IconButton(
            icon: Icon(
              Mdi.delete,
              color: Colors.red[800].withOpacity(0.7),
            ),
            onPressed: () {
              CustomDialog(
                context: context,
                title: textTranslation(ar: 'حذف المنتج', en: 'Delete Product'),
                content: TextWidget(textTranslation(
                        ar: 'هل انت متأكد انك تريد حذف هذا المنتج؟',
                        en: 'Are you sure that you want to delete this product?') +
                    '\n' +
                    textTranslation(
                        ar: 'لن يمكنك التراجع عن هذا الاختيار بعد الحذف!',
                        en: 'You can\'t restore it back once you deleted it!')),
                firstButtonColor: Colors.red,
                secondButtonColor: Colors.black54,
                firstButtonFunction: () {
                  Navigator.of(context).pop();
                  loadingScreen(
                      context: context,
                      function: () async {
                        await Firestore.instance
                            .collection(widget.product.reference.split('/')[0])
                            .document(widget.product.reference.split('/')[1])
                            .updateData({
                          'deleted': true,
                        });
                        updatedMyProductsPage.value = DateTime.now().millisecondsSinceEpoch;
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
                },
                secondButtonFunction: () => Navigator.of(context).pop(),
                firstButtonText: textTranslation(ar: 'حذف المنتج', en: 'Delete Product'),
                secondButtonText: textTranslation(ar: 'تراجع', en: 'Cancel'),
              );
            },
          ),
        ],
      );
    if (widget.liked) {
      return IconButton(
          icon: Icon(
            widget.product is ProductRequest ? Icons.bookmark : Icons.favorite,
            color: widget.product is ProductRequest ? Colors.green[600] : Colors.red,
            size: 35,
          ),
          onPressed: widget.product is ProductRequest
              ? null
              : () {
                  setState(() {
                    widget.liked = false;
                    widget.product.removeFromLikes();
                  });
                });
    } else {
      return Builder(
        builder: (context) => IconButton(
            icon: Icon(
              widget.product is ProductRequest ? Icons.bookmark_border : Icons.favorite_border,
              color: Colors.grey,
              size: 35,
            ),
            onPressed: widget.product is ProductRequest
                ? null
                : () {
                    if (!isSignedIn()) {
                      final snackBar = SnackBar(
                        content: Text(
                            textTranslation(
                                ar: 'الرجاء تسجيل الدخول لاضافة المنتجات الى المفضلة',
                                en: 'Please sign in to add products to the favorites'),
                            textAlign: TextAlign.right),
                        backgroundColor: Colors.black.withOpacity(0.7),
                        elevation: 0,
                        duration: Duration(seconds: 2),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                    } else {
                      setState(() {
                        widget.liked = true;
                        widget.product.addToLikes();
                      });
                    }
                  }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: widget.product.productName,
      child: Builder(
        builder: (context) => ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Card(
                margin: EdgeInsets.only(bottom: 15),
                elevation: 5,
                child: CarouselSlider.builder(
                  itemCount: widget.product.productImagesURLs.length,
                  autoPlay: true,
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  aspectRatio: 9 / 8,
                  scrollPhysics: BouncingScrollPhysics(),
                  enableInfiniteScroll: true,
                  itemBuilder: (BuildContext context, int itemIndex) => Row(
                    children: <Widget>[
                      Expanded(
                        child: ImageFade(
                          image: NetworkImage(widget.product.productImagesURLs[itemIndex]),
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
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                )),
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
                                  maxFontSize: 35, minFontSize: 18, style: TextStyle(fontWeight: FontWeight.bold)),
                              TextWidget(
                                  '${textTranslation(ar: 'المنتج', en: 'Product')} ${widget.product.reference.split('/')[1]}#',
                                  maxFontSize: 12,
                                  minFontSize: 11,
                                  style: TextStyle(color: Colors.grey)),
                              AutoSizeText(
                                widget.product.productDescription,
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ),
                        if (widget.product is ProductOffer) likeButton(),
                      ],
                    ),
                    if (widget.product is ProductOffer) _buildCategoryChips(widget.product),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextWidget(
                          widget.product is ProductOffer
                              ? '${widget.product.productPrice} ${textTranslation(ar: 'ريال', en: 'SR')}'
                              : '${widget.product.productPrice} ${textTranslation(ar: 'ريال كحد اقصى', en: 'SR Maximum')}',
                          maxFontSize: 25,
                          minFontSize: 21,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Divider(color: Colors.black.withOpacity(0.5)),
                    if (widget.requestType != RequestType.myRequest)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                              widget.product is ProductOffer
                                  ? textTranslation(ar: 'البائع', en: 'Seller')
                                  : textTranslation(ar: 'الزبون', en: 'Customer'),
                              maxFontSize: 25,
                              minFontSize: 20,
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                                        if (isSignedIn() && currentUser.location != null)
                                          FutureBuilder(
                                            future: calculateDistance(widget.product.userUid),
                                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                              if (snapshot.hasError) {
                                                return TextWidget(
                                                  textTranslation(ar: 'لم يحدد موقع البائع', en: 'Seller not located'),
                                                  minFontSize: 11,
                                                  maxFontSize: 14,
                                                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                                                );
                                              } else if (snapshot.hasData) {
                                                return Directionality(
                                                  textDirection: TextDirection.rtl,
                                                  child: TextWidget(
                                                    '${textTranslation(ar: 'يبعد عنك', en: 'Away')} ${snapshot.data}',
                                                    minFontSize: 16,
                                                    maxFontSize: 18,
                                                  ),
                                                );
                                              }
                                              return TextWidget('${textTranslation(ar: 'يبعد عنك', en: 'Away')} ...',
                                                  minFontSize: 16, maxFontSize: 18);
                                            },
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 3),
                                          child: FutureBuilder(
                                            future: Firestore.instance
                                                .collection('Users')
                                                .document(widget.product.userUid)
                                                .get(),
                                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                              if (!snapshot.hasData) return Rating(null);
                                              return Rating(snapshot.data.data['rating'].toDouble());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                      text: textTranslation(ar: 'ارسال رسالة', en: 'Send Message'),
                                      function: () async {
                                        await sendPrivateMessage(context, widget.product.userUid);
                                      }),
                                ],
                              ),
                            ),
                          ),
                          widget.requestType != RequestType.acceptedRequest
                              ? Padding(
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
                                                    Text(
                                                      widget.product is ProductOffer
                                                          ? textTranslation(ar: 'اضافة الى العربة', en: 'Add to Cart')
                                                          : textTranslation(
                                                              ar: 'تقديم عرض للزبون', en: 'Maker an Offer'),
                                                    ),
                                                  ],
                                                )),
                                                Icon(widget.product is ProductOffer
                                                    ? Icons.add_shopping_cart
                                                    : Icons.local_offer),
                                              ],
                                            ),
                                          ),
                                          function: () {
                                            if (!isSignedIn()) {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    textTranslation(
                                                        ar: 'الرجاء تسجيل الدخول لاضافة المنتجات الى العربة',
                                                        en: 'Please sign in to add product into your cart'),
                                                    textAlign: TextAlign.right),
                                                backgroundColor: Colors.black.withOpacity(0.7),
                                                elevation: 0,
                                                duration: Duration(seconds: 2),
                                              );
                                              Scaffold.of(context).showSnackBar(snackBar);
                                            } else if (widget.product is ProductOffer) {
                                              widget.product.addToCart();
                                              final snackBar = SnackBar(
                                                content: Text(
                                                    textTranslation(
                                                        ar: 'تم اضافة المنتج الى العربة', en: 'Added to Cart'),
                                                    textAlign: TextAlign.right),
                                                backgroundColor: Colors.black.withOpacity(0.7),
                                                elevation: 0,
                                                duration: Duration(seconds: 2),
                                              );
                                              Scaffold.of(context).showSnackBar(snackBar);
                                            } else if (widget.product is ProductRequest) {
                                              PagePush(context, MakeOffer(widget.product.reference));
                                            }
                                          }),
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
                                                  Text(widget.product is ProductOffer
                                                      ? textTranslation(
                                                          ar: 'تبليغ عن منتج مخالف', en: 'Report a Violation')
                                                      : textTranslation(
                                                          ar: 'تبليغ عن طلب مخالف', en: 'Report a Violation')),
                                                ],
                                              )),
                                              Icon(Icons.priority_high),
                                            ],
                                          ),
                                        ),
                                        function: () => PagePush(
                                          context,
                                          TicketPage(
                                            ticketType: widget.product is ProductOffer
                                                ? TicketType.productComplaint
                                                : TicketType.requestComplaint,
                                            data: widget.product.reference,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
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
                                                    Text(textTranslation(
                                                        ar: 'الاتصال بالزبون', en: 'Call the Customer')),
                                                  ],
                                                )),
                                                Icon(Mdi.phoneOutline),
                                              ],
                                            ),
                                          ),
                                          function: () {
                                            loadingScreen(
                                                context: context,
                                                function: () async {
                                                  await Firestore.instance
                                                      .collection('Users')
                                                      .document(widget.product.userUid)
                                                      .get()
                                                      .then((onValue) async {
                                                    Navigator.of(context).pop();
                                                    try {
                                                      launch("tel://${onValue.data['phone']}");
                                                    } catch (e) {}
                                                  });
                                                });
                                          }),
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
                                                    Text(textTranslation(
                                                        ar: 'عنوان الزبون', en: 'Customer\'s Location')),
                                                  ],
                                                )),
                                                Icon(Mdi.mapMarkerRadiusOutline),
                                              ],
                                            ),
                                          ),
                                          function: () async {
                                            loadingScreen(
                                                context: context,
                                                function: () async {
                                                  await getUserLocation(widget.product.userUid)
                                                      .then((Location onValue) {
                                                    Navigator.of(context).pop();
                                                    MapUtils.openMap(onValue.lat, onValue.lng);
                                                  });
                                                });
                                          }),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    if (widget.isMyRequest)
                      FutureBuilder(
                        future: Firestore.instance
                            .collection('ProductRequests')
                            .document(widget.product.reference.split('/')[1])
                            .collection('offers')
                            .getDocuments(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData)
                            return Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: SpinKitRotatingCircle(
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            );
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return OfferRow(snapshot.data.documents[index].data);
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCategoryChips(ProductOffer product) {
    List<String> categories = new List();
    if (currentAppLanguage == AppLanguage.arabic) {
      categories.add(categories_arabic.keys.elementAt(product.mainCategory));
      product.subCategories
          .forEach((i) => categories.add(categories_arabic[categories_arabic.keys.elementAt(product.mainCategory)][i]));
    } else {
      categories.add(categories_english.keys.elementAt(product.mainCategory));
      product.subCategories.forEach(
          (i) => categories.add(categories_english[categories_english.keys.elementAt(product.mainCategory)][i]));
    }

    return Wrap(
      children: List.generate(categories.length, (value) => CategoryChip(categories[value])),
    );
  }
}
