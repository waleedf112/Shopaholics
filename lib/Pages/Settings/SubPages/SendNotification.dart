import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/Translation.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'package:http/http.dart' as http;

class SendNotification extends StatelessWidget {
  TextEditingController controllerTitle = new TextEditingController();
  TextEditingController controllerBody = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'ارسل اشعار', en: 'Send Notification'),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Directionality(
                textDirection: layoutTranslation(),
                child: TextFormField(
                  textDirection: layoutTranslation(),
                  maxLines: 1,
                  controller: controllerTitle,
                  validator: (String value) => null,
                  decoration: InputDecoration(
                    labelText: textTranslation(ar: 'اكتب عنوان الاشعار', en: 'Notification Title'),
                    labelStyle: TextStyle(fontSize: 14),
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Directionality(
                textDirection: layoutTranslation(),
                child: TextFormField(
                  textDirection: layoutTranslation(),
                  maxLines: 2,
                  controller: controllerBody,
                  validator: (String value) => null,
                  decoration: InputDecoration(
                    labelText: textTranslation(ar: 'اكتب رسالة الاشعار', en: 'Write the notification body'),
                    labelStyle: TextStyle(fontSize: 14),
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SimpleButton(
              textTranslation(ar: 'ارسال', en: 'Send'),
              function: () {
                if (controllerTitle.text.trim().isNotEmpty && controllerBody.text.trim().isNotEmpty)
                  loadingScreen(
                      context: context,
                      function: () async {
                        var url =
                            'https://us-central1-shopholic-app.cloudfunctions.net/SendGlobalNofitication?head=${controllerTitle.text.trim()}&body=${controllerBody.text.trim()}';
                        await http.post(url);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      });
              },
            ),
          )
        ],
      ),
    );
  }
}
