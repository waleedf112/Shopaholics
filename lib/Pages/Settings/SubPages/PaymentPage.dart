import 'package:awesome_card/awesome_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../Classes/User.dart';
import '../../../Functions/Translation.dart';
import '../../../Widgets/Button.dart';
import '../../../Widgets/CustomDialog.dart';
import '../../../Widgets/SecondaryView.dart';
import '../../../Widgets/loadingDialog.dart';

class PaymentPage extends StatefulWidget {
  bool fetched = false;
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool showBack = false;

  TextEditingController cardNumberController = new TextEditingController();
  TextEditingController cardyearController = new TextEditingController();
  TextEditingController cardmonthController = new TextEditingController();
  TextEditingController cardCVVController = new TextEditingController();
  TextEditingController cardHolderNameController = new TextEditingController();
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'وسيلة الدفع', en: ''),
      child: SafeArea(
        child: FutureBuilder(
          future: Firestore.instance.collection('Users').document(currentUser.uid).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return SpinKitRotatingCircle(color: Colors.grey.withOpacity(0.3));
            } else {
              if (snapshot.data.data['Card'] != null && !widget.fetched) {
                cardNumberController.text = snapshot.data.data['Card']['cardNumber'];
                cardyearController.text = snapshot.data.data['Card']['cardyear'];
                cardmonthController.text = snapshot.data.data['Card']['cardmonth'];
                cardCVVController.text = snapshot.data.data['Card']['cardCVV'];
                cardHolderNameController.text = snapshot.data.data['Card']['cardHolderName'];
                widget.fetched = true;
              }
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            CreditCard(
                              cardNumber: cardNumberController.text,
                              cardExpiry: cardyearController.text + '/' + cardmonthController.text,
                              cardHolderName: cardHolderNameController.text.isEmpty
                                  ? 'Card Holder Name'
                                  : cardHolderNameController.text,
                              cvv: cardCVVController.text,
                              bankName: textTranslation(ar:'بطاقة ائتمانية',en:''),
                              cardType: CardType.visa,
                              showBackSide: showBack,
                              frontBackground: CardBackgrounds.black,
                              backBackground: CardBackgrounds.white,
                              showShadow: true,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(hintText: textTranslation(ar: "رقم البطاقة", en: '')),
                                    maxLength: 19,
                                    controller: cardNumberController,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextFormField(
                                    decoration: InputDecoration(hintText: "CVV"),
                                    maxLength: 3,
                                    controller: cardCVVController,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    focusNode: _focusNode,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          decoration: InputDecoration(hintText: textTranslation(ar: "الشهر", en: '')),
                                          maxLength: 2,
                                          controller: cardyearController,
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          decoration: InputDecoration(hintText: textTranslation(ar: "السنة", en: '')),
                                          maxLength: 4,
                                          controller: cardmonthController,
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: TextFormField(
                                    decoration: InputDecoration(hintText: textTranslation(ar: "اسم حامل البطاقة", en: '')),
                                    controller: cardHolderNameController,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SimpleButton(textTranslation(ar: 'حفظ وسيلة الدفع', en: ''), function: () {
                    loadingScreen(
                        context: context,
                        function: () async {
                          await Firestore.instance.collection('Users').document(currentUser.uid).updateData({
                            'Card': {
                              'cardNumber': cardNumberController.text,
                              'cardyear': cardyearController.text,
                              'cardmonth': cardmonthController.text,
                              'cardCVV': cardCVVController.text,
                              'cardHolderName': cardHolderNameController.text,
                            }
                          }).whenComplete(() {
                            Navigator.of(context).pop();
                            CustomDialog(
                                context: context,
                                title: textTranslation(ar: 'تم حفظ البطاقة', en: ''),
                                content: Text(
                                  textTranslation(ar: 'تم حفظ البطاقة بنجاح!', en: ''),
                                  textDirection: TextDirection.rtl,
                                ),
                                firstButtonColor: Colors.black54,
                                firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                                firstButtonFunction: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                          });
                        });
                  }),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
