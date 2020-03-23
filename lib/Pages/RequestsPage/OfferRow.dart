import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/TradeOffer.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Functions/distanceCalculator.dart';
import 'package:shopaholics/Pages/Settings/SubPages/MyOrders.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'package:shopaholics/Widgets/rating.dart';

import 'RequestsPage.dart';

class OfferRow extends StatelessWidget {
  Map<String, dynamic> trade;
  OfferRow(this.trade);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection('Users').document(trade['traderUid']).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData)
          return Stack(
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(bottom: 10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextWidget('....', minFontSize: 16, maxFontSize: 18),
                              TextWidget('يبعد عنك ...', minFontSize: 11, maxFontSize: 13),
                              Rating(null),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '.... ريال',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                child: Text('قبول العرض'),
                                function: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: SpinKitRotatingCircle(
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          );
        Map trader = snapshot.data.data;
        return Card(
          margin: EdgeInsets.only(bottom: 10),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextWidget(trader['displayName'], minFontSize: 16, maxFontSize: 18),
                        FutureBuilder(
                          future: calculateDistance(trade['traderUid']),
                          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasError) {
                              return TextWidget(
                                'لم يحدد موقع البائع',
                                minFontSize: 11,
                                maxFontSize: 13,
                                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                              );
                            } else if (snapshot.hasData) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextWidget(
                                  'يبعد عنك ${snapshot.data}',
                                  minFontSize: 11,
                                  maxFontSize: 13,
                                ),
                              );
                            }
                            return TextWidget('يبعد عنك ...', minFontSize: 18, maxFontSize: 20);
                          },
                        ),
                        Rating(trader['rating']),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${trade['price']} ريال',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          child: Text('قبول العرض'),
                          function: () {
                            CustomDialog(
                                context: context,
                                title: 'قبول العرض',
                                content: Text(
                                  'هل انت متأكد انك تريد قبول العرض من ' +
                                      '${trader['displayName']}' +
                                      ' بسعر ' +
                                      '${trade['price']} ريال؟' +
                                      '\n' +
                                      'سيتم رفض جميع الطلبات الاخرى!',
                                  textAlign: TextAlign.center,
                                ),
                                firstButtonColor: Colors.green,
                                firstButtonText: 'قبول العرض',
                                secondButtonText: 'تراجع',
                                secondButtonColor: Colors.black54,
                                secondButtonFunction: () => Navigator.of(context).pop(),
                                firstButtonFunction: () {
                                  Navigator.of(context).pop();
                                  loadingScreen(
                                      context: context,
                                      function: () async {
                                        await tradeOfferAccept(trade).whenComplete(() {
                                          updatedRequestsPage.value = TimeOfDay.now();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          PagePush(context, MyOrdersPage());
                                        });
                                      });
                                });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                if (trade['info'] != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextWidget(trade['info']),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
