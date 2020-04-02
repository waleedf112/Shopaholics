import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../Classes/Order.dart';
import '../../Classes/Product.dart';
import '../../Classes/User.dart';
import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Functions/isEmailVerified.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/CustomDialog.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/TextWidget.dart';
import '../../Widgets/loadingDialog.dart';
import '../Settings/SubPages/Addresses.dart';
import '../Settings/SubPages/MyOrders.dart';
import '../Settings/SubPages/PaymentPage.dart';
import 'noProductsInCart.dart';

class ShoppingCart extends StatefulWidget {
  int productsPrice = 0;
  int delivery = 0;
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  Future<void> updatePrice({bool setStateAfterFinish = true}) {
    widget.productsPrice = 0;
    currentUser.getCart().then((onValue) {
      for (int i = 0; i < onValue.length; i++)
        widget.productsPrice += onValue[i]['product']['productPrice'] * onValue[i]['count'];

      if (widget.productsPrice > 0) widget.delivery = 25;
      if (setStateAfterFinish) setState(() {});
    });
  }

  @override
  void initState() {
    if (isSignedIn()) updatePrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'العربة', en: ''),
      function: () => setState(() {}),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            !isSignedIn()
                ? Expanded(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[NoProductsInCart()],
                  ))
                : FutureBuilder(
                    future: currentUser.getCart(),
                    builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.isEmpty)
                          return Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[NoProductsInCart()],
                          ));
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    ProductOffer product = new ProductOffer.retrieveFromDatabase(
                                      snapshot.data[index]['product'],
                                      snapshot.data[index]['product']['id'].toString(),
                                    );
                                    int quantity = snapshot.data[index]['count'];
                                    TextEditingController controller =
                                        new TextEditingController(text: quantity.toString());
                                    // widget.productsPrice += product.productPrice * quantity;

                                    return quantity == 0
                                        ? Container()
                                        : Dismissible(
                                            key: Key(product.hashCode.toString()),
                                            confirmDismiss: (a) {
                                              CustomDialog(
                                                  context: context,
                                                  title: textTranslation(ar: 'حذف المنتج', en: ''),
                                                  content: Text(
                                                    textTranslation(
                                                        ar: 'هل انت متأكد انك تريد حذف هذا المنتج من العربة؟', en: ''),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  firstButtonColor: Colors.red,
                                                  firstButtonText: textTranslation(ar: 'حذف المنتج', en: ''),
                                                  secondButtonText: textTranslation(ar: 'الغاء', en: ''),
                                                  secondButtonColor: Colors.black54,
                                                  firstButtonFunction: () {
                                                    quantity = 0;
                                                    currentUser.modifyItemInCart(
                                                        quantity: quantity, ref: product.reference);

                                                    Navigator.of(context).pop();
                                                    updatePrice();
                                                  },
                                                  secondButtonFunction: () {
                                                    Navigator.of(context).pop();
                                                  });
                                            },
                                            background: Container(
                                              color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8),
                                                          child: Icon(
                                                            Icons.cancel,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          textTranslation(ar: 'حذف', en: ''),
                                                          style: TextStyle(color: Colors.white, fontSize: 23),
                                                        )
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8),
                                                          child: Icon(
                                                            Icons.cancel,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          textTranslation(ar: 'حذف', en: ''),
                                                          style: TextStyle(color: Colors.white, fontSize: 23),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            child: Card(
                                              shape: Border(),
                                              elevation: 4,
                                              margin: EdgeInsets.symmetric(vertical: 5),
                                              child: Directionality(
                                                textDirection: TextDirection.rtl,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                        flex: 3,
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
                                                              TextWidget(
                                                                  '${product.productPrice} ${textTranslation(ar: 'ريال', en: '')}',
                                                                  style: TextStyle(color: Colors.red[700])),
                                                            ],
                                                          ),
                                                        )),
                                                    Flexible(
                                                      child: Form(
                                                        child: Container(
                                                          width: 30,
                                                          child: TextFormField(
                                                            controller: controller,
                                                            textAlign: TextAlign.center,
                                                            maxLines: 1,
                                                            keyboardType: TextInputType.numberWithOptions(),
                                                            inputFormatters: <TextInputFormatter>[
                                                              WhitelistingTextInputFormatter.digitsOnly
                                                            ],
                                                            onChanged: (q) async {
                                                              if (q.isNotEmpty && q != '0') {
                                                                quantity = int.parse(q);
                                                                await updatePrice(setStateAfterFinish: false);
                                                                currentUser.modifyItemInCart(
                                                                    quantity: quantity, ref: product.reference);
                                                              } else {
                                                                quantity = 1;
                                                                await updatePrice(setStateAfterFinish: false);
                                                                currentUser.modifyItemInCart(
                                                                    quantity: quantity, ref: product.reference);
                                                              }
                                                            },
                                                            decoration: InputDecoration.collapsed(
                                                                hintText: '0', border: OutlineInputBorder()),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Image.network(
                                                          product.productImagesURLs[0],
                                                          height: 120,
                                                          fit: BoxFit.fitHeight,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Divider(color: Colors.black54, height: 0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    child: Row(
                                      textDirection: TextDirection.rtl,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              _infoRow(
                                                  title: textTranslation(ar: 'السلع', en: ''),
                                                  value: widget.productsPrice),
                                              _infoRow(
                                                  title: textTranslation(ar: 'التوصيل', en: ''),
                                                  value: widget.delivery),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              _infoRow(
                                                  title: textTranslation(ar: 'المجموع', en: ''),
                                                  value: widget.productsPrice + widget.delivery,
                                                  isBold: true),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SimpleButton(
                                    textTranslation(ar: 'تأكيد الشراء', en: ''),
                                    function: () async {
                                      if (currentUser.location == null) {
                                        CustomDialog(
                                            context: context,
                                            title: textTranslation(ar: 'تحديد العنوان', en: ''),
                                            content: Text(
                                              textTranslation(ar: 'يجب عليك تحديد موقع التوصيل قبل الطلب', en: '') +
                                                  '\n' +
                                                  textTranslation(ar: 'هل تريد تحديد موقعك الآن؟', en: ''),
                                              textAlign: TextAlign.center,
                                            ),
                                            firstButtonColor: Colors.black54,
                                            secondButtonColor: Colors.red,
                                            firstButtonText: textTranslation(ar: 'تحديد الموقع', en: ''),
                                            secondButtonText: textTranslation(ar: 'تراجع', en: ''),
                                            firstButtonFunction: () {
                                              Navigator.of(context).pop();
                                              PagePush(context, AddressesPage());
                                            },
                                            secondButtonFunction: () => Navigator.of(context).pop());
                                      } else {
                                        bool isVerified = (await isEmailVerified(context, false));
                                        bool hasCard = (await Firestore.instance
                                                    .collection('Users')
                                                    .document(currentUser.uid)
                                                    .get())
                                                .data['Card'] !=
                                            null;

                                        if (isVerified && hasCard) {
                                          loadingScreen(
                                              context: context,
                                              function: () async {
                                                Order _receipt = new Order(snapshot.data);
                                                await _receipt.placeNewOrder();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              }).whenComplete(() {
                                            PagePush(context, MyOrdersPage());
                                          });
                                        } else {
                                          PagePush(context, PaymentPage());
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }

                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SpinKitHourGlass(color: Colors.grey.withOpacity(0.4)),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
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
                value.toString() + textTranslation(ar: ' ريال', en: ''),
                style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
              ),
            ),
          ],
        ),
      ),
    );
