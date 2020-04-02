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
      if (ticketType == TicketType.orderComplaint) return textTranslation(ar: 'شكوى عن الفاتوره', en: '');
      if (ticketType == TicketType.productComplaint) return textTranslation(ar: 'شكوى عن منتج', en: '');
      if (ticketType == TicketType.requestComplaint) return textTranslation(ar: 'شكوى عن طلب', en: '');
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
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: controller,
                          textDirection: TextDirection.rtl,
                          validator: (String s) {
                            if (s.trim().isEmpty) return textTranslation(ar: 'النص فارغ', en: '');
                          },
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: textTranslation(
                                    ar: 'اكتب نص الشكوى بالتفصيل حتى تتم مساعدتك باسرع وقت!\n', en: '') +
                                textTranslation(
                                    ar: 'اذا كانت الشكوى بخصوص طلب سابق, الرجاء تقديم شكوى من قائمة "طلباتي" او اكتب رقم طلبك هنا.',
                                    en: ''),
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
              textTranslation(ar: 'تقديم البلاغ', en: ''),
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
                    title: textTranslation(ar: 'تم', en: ''),
                    content: Text(
                      textTranslation(
                          ar: 'تم ارسال الشكوى بنجاح!\nشكراً لك على مساعدتك وستتم معالجه طلبك في اسرع وقت', en: ''),
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
