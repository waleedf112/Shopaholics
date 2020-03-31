import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

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
      if (ticketType == TicketType.orderComplaint) return 'شكوى عن الفاتوره';
      if (ticketType == TicketType.productComplaint) return 'شكوى عن منتج';
      if (ticketType == TicketType.requestComplaint) return 'شكوى عن طلب';
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
                            if (s.trim().isEmpty) return 'النص فارغ';
                          },
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: 'اكتب نص الشكوى بالتفصيل حتى تتم مساعدتك باسرع وقت!\n' +
                                'اذا كانت الشكوى بخصوص طلب سابق, الرجاء تقديم شكوى من قائمة "طلباتي" او اكتب رقم طلبك هنا.',
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
              'تقديم البلاغ',
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
                    title: 'تم',
                    content: Text(
                      'تم ارسال الشكوى بنجاح!\nشكراً لك على مساعدتك وستتم معالجه طلبك في اسرع وقت',
                      textAlign: TextAlign.center,
                    ),
                    firstButtonText: 'حسناً',
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
