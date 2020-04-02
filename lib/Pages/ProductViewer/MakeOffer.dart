import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../Classes/TradeOffer.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/CustomDialog.dart';
import '../../Widgets/SecondaryView.dart';
import '../../Widgets/loadingDialog.dart';
import '../RequestsPage/RequestsPage.dart';

class MakeOffer extends StatelessWidget {
  String id;
  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController productPriceController = new TextEditingController();
  TextEditingController otherController = new TextEditingController();
  MakeOffer(this.id);
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'تقديم عرض', en: ''),
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
                            if (x < 1) return textTranslation(ar: 'السعر اقل من ريال واحد', en: '');
                            if (x > 99999) return textTranslation(ar: 'السعر اعلى من المسموح به', en: '');
                          } catch (e) {
                            return textTranslation(ar: 'السعر غير صحيح', en: '');
                          }
                        },
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'السعر المقترح', en: ''),
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
                          labelText: textTranslation(ar: 'معلومات اخرى للزبون (اختياري)', en: ''),
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
                textTranslation(ar: 'تقديم العرض', en: ''),
                function: () {
                  if (formKey.currentState.validate()) {
                    loadingScreen(
                        context: context,
                        function: () async {
                          //updatedRequestsPage.value = TimeOfDay.now();
                          TradeOffer tradeOffer = new TradeOffer(
                            price: int.parse(productPriceController.text),
                            info: otherController.text.trim(),
                            requestId: int.parse(id.split('/')[1]),
                          );

                          await tradeOffer.makeOffer().then((hasError) {
                            updatedRequestsPage.value = DateTime.now().millisecondsSinceEpoch;
                            Navigator.of(context).pop();
                            CustomDialog(
                                context: context,
                                title: hasError
                                    ? textTranslation(ar: 'خطأ', en: 'Error')
                                    : textTranslation(ar: 'تم تقديم العرض', en: ''),
                                content: AutoSizeText(hasError
                                    ? textTranslation(ar: 'عذراً, فقد تم حجز الطلب مسبقاً', en: '')
                                    : textTranslation(ar: 'تم تقديم عرضك للزبون بنجاح!', en: '')),
                                dismissible: false,
                                firstButtonColor: Colors.black45,
                                firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
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
