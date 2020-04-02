import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Classes/User.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/CustomDialog.dart';
import '../../Widgets/SecondaryView.dart';

enum TicketType { productComplaint, requestComplaint, orderComplaint }

class TicketPage extends StatelessWidget {
  TicketType ticketType;
  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController controller = new TextEditingController();
  String data;
  TicketPage({@required this.ticketType, this.data});

  @override
  Widget build(BuildContext context) {
    String _getTitle() {
      if (ticketType == TicketType.orderComplaint)
        return textTranslation(ar: 'شكوى عن الفاتوره', en: 'Complaint about an order');
      if (ticketType == TicketType.productComplaint)
        return textTranslation(ar: 'شكوى عن منتج', en: 'Complaint about a product');
      if (ticketType == TicketType.requestComplaint)
        return textTranslation(ar: 'شكوى عن طلب', en: 'Complaint about a request');
      return null;
    }

    return SecondaryView(
      title: _getTitle(),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Directionality(
                        textDirection: layoutTranslation(),
                        child: TextFormField(
                          controller: controller,
                          textDirection: layoutTranslation(),
                          validator: (String s) {
                            if (s.trim().isEmpty) return textTranslation(ar: 'النص فارغ', en: 'Empty');
                          },
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: textTranslation(
                                    ar: 'اكتب نص الشكوى بالتفصيل حتى تتم مساعدتك باسرع وقت!\n',
                                    en:
                                        'Type your complaint in the most details you could, so we can help you as fast as possible') +
                                textTranslation(
                                    ar: 'اذا كانت الشكوى بخصوص طلب سابق, الرجاء تقديم شكوى من قائمة "طلباتي" او اكتب رقم طلبك هنا.',
                                    en: 'if you want to complian about your order, please fo to (My Order) page or type your order number here.'),
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SimpleButton(
              textTranslation(ar: 'تقديم البلاغ', en: 'Send'),
              function: () async {
                if (formKey.currentState.validate()) {
                  await Firestore.instance.collection('Tickets').add({
                    'type': ticketType.toString(),
                    'info': controller.text,
                    'ref': data,
                    'resolved': false,
                    'uid': currentUser.uid,
                  });
                  CustomDialog(
                    context: context,
                    title: textTranslation(ar: 'تم', en: 'Done'),
                    content: Text(
                      textTranslation(
                          ar: 'تم ارسال الشكوى بنجاح!\nشكراً لك على مساعدتك وستتم معالجه طلبك في اسرع وقت',
                          en: 'Thank you, your complaint has been sent and will be resolved as fast as we can.'),
                      textAlign: TextAlign.center,
                    ),
                    firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                    firstButtonColor: Colors.black54,
                    firstButtonFunction: () {
                      Navigator.of(context).pop(false);
                      Navigator.of(context).pop(false);
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
