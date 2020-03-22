import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/TradeOffer.dart';
import 'package:shopaholics/Pages/RequestsPage/RequestsPage.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';

class MakeOffer extends StatelessWidget {
  String id;
  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController productPriceController = new TextEditingController();
  TextEditingController otherController = new TextEditingController();
  MakeOffer(this.id);
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'تقديم عرض',
      child: Form(
        key: formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        controller: productPriceController,
                        keyboardType: TextInputType.number,
                        validator: (String value) {
                          try {
                            int x = int.parse(value);
                            if (x < 1) return 'السعر اقل من ريال واحد';
                            if (x > 99999) return 'السعر اعلى من المسموح به';
                          } catch (e) {
                            return 'السعر غير صحيح';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'السعر المقترح',
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    //height: 90,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        maxLines: 5,
                        controller: otherController,
                        validator: (String value) => null,
                        decoration: InputDecoration(
                          labelText: 'معلومات اخرى للزبون (اختياري)',
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
              child: SimpleButton(
                'تقديم العرض',
                function: () {
                  if (formKey.currentState.validate()) {
                    loadingScreen(
                        context: context,
                        function: () async {
                          TradeOffer tradeOffer = new TradeOffer(
                            price: int.parse(productPriceController.text),
                            info: otherController.text.trim(),
                            requestId: int.parse(id.split('/')[1]),
                          );
                          await tradeOffer.makeOffer().whenComplete(() {
                            updatedRequestsPage.value = TimeOfDay.now();
                            Navigator.of(context).pop();
                            CustomDialog(
                                context: context,
                                title: 'تم تقديم العرض',
                                content: AutoSizeText('تم تقديم عرضك للزبون بنجاح!'),
                                dismissible: false,
                                firstButtonColor: Colors.black45,
                                firstButtonText: 'حسناً',
                                firstButtonFunction: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                          });
                        });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
