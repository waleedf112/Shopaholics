import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Classes/User.dart';
import '../../../Classes/UserRole.dart';
import '../../../Functions/PagePush.dart';
import '../../../Functions/Translation.dart';
import '../../../Functions/isEmailVerified.dart';
import '../../../Widgets/AlertMessage.dart';
import '../../../Widgets/Button.dart';
import '../../../Widgets/CustomDialog.dart';
import '../../../Widgets/DropDownMenu.dart';
import '../../../Widgets/SecondaryView.dart';
import '../../../Widgets/TextWidget.dart';
import '../../../Widgets/loadingDialog.dart';

ValueNotifier<bool> _accepted = ValueNotifier<bool>(false);

class RolesPage extends StatefulWidget {
  String role = roleNames[currentUser.getRole()];
  String location;
  GlobalKey<FormState> formKey = new GlobalKey();
  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  Future<File> copyAsset() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File tempFile = File('$tempPath/copy.pdf');
    ByteData bd = await rootBundle.load('assets/personal_shopper.pdf');
    await tempFile.writeAsBytes(bd.buffer.asUint8List(), flush: true);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: textTranslation(ar: 'نوع الحساب', en: 'Account Type'),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            AlertMessage(
              message: textTranslation(
                      ar: 'تقديم طلب على تغيير نوع الحساب لايعني الموافقة مباشرةً.',
                      en: 'Requesting an upgrade of your account does not mean that it will be accepted') +
                  '\n' +
                  textTranslation(
                      ar: 'سيتم الرد على طلبك من خلال 24 ساعة الى 48 ساعة.',
                      en: 'your request has to be reviewd by admins, expect a response within 24 hours to 48 hours.'),
              centerIcon: true,
              maxLines: 3,
            ),
            SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextWidget(textTranslation(ar: 'نوع الحساب:', en: 'Account type'), minFontSize: 18, maxFontSize: 18),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: FutureBuilder(
                      future: currentUser.getRequestedRole(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        Widget _widget({int requestedRole, int currentRole, bool pending}) {
                          return Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              TextWidget(
                                pending
                                    ? roleNames[requestedRole] + textTranslation(ar: ' (قيد التنفيذ)', en: ' (Pending)')
                                    : roleNames[currentRole],
                                minFontSize: 15,
                                maxFontSize: 15,
                              ),
                              SizedBox(width: 5),
                              Icon(
                                pending ? Icons.pause_circle_filled : Icons.check_circle,
                                size: 18,
                                color: pending ? Colors.orange : Colors.green[500],
                              ),
                            ],
                          );
                        }

                        if (!snapshot.hasData)
                          return SpinKitHourGlass(
                            color: Colors.grey.withOpacity(0.2),
                            size: 20,
                          );
                        return _widget(
                            currentRole: snapshot.data['currentRole'],
                            requestedRole: snapshot.data['requestedRole'],
                            pending: snapshot.data['pending']);
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: TextWidget(textTranslation(ar: 'تغيير نوع الحساب', en: 'Change account type'),
                        minFontSize: 15, maxFontSize: 18),
                  ),
                  Expanded(
                    child: CustomDropDownMenu(
                      hint: textTranslation(ar: 'اختر نوع الحساب', en: 'choose type'),
                      value: widget.role,
                      function: (p) {
                        setState(() {
                          widget.role = p;
                        });
                      },
                      children: roleNames,
                    ),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: TextWidget(textTranslation(ar: 'موقع متجرك', en: 'Your shop location'),
                        minFontSize: 15, maxFontSize: 18),
                  ),
                  Expanded(
                    child: CustomDropDownMenu(
                      hint: textTranslation(ar: 'اختر موقعك', en: 'location'),
                      value: widget.location,
                      function: (p) {
                        setState(() {
                          widget.location = p;
                          controller1.text = '';
                        });
                      },
                      //TODO english - arabic
                      children: ['داخل السعودية', 'خارج السعودية'],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: widget.formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        enabled: widget.location != null,
                        controller: controller1,
                        validator: (String value) =>
                            value.trim().isEmpty ? textTranslation(ar: 'الحقل فارغ!', en: 'Empty') : null,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: widget.location == null
                              ? textTranslation(
                                  ar: 'الرجاء اختيار موقع متجرك من الاعلى', en: 'Please choose a location')
                              : widget.location == 'داخل السعودية'
                                  ? textTranslation(ar: 'ادخل حسابك في (معروف)', en: 'Maroof account')
                                  : textTranslation(ar: 'ادخل رقم الهوية', en: 'ID Number'),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: controller2,
                        validator: (String value) =>
                            value.trim().isEmpty ? textTranslation(ar: 'الحقل فارغ!', en: 'empty') : null,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: textTranslation(ar: 'ادخل رقم حسابك البنكي', en: 'Bank IBAN Number'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _accepted,
              builder: (BuildContext context, bool accepted, Widget child) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          child: TextWidget(textTranslation(
                              ar: 'قبول الشروط والاحكام, اضغط هنا لقراءة الشروط',
                              en: 'Accept the roles and policies, press here to read them.')),
                          onPressed: () => PagePush(
                              context,
                              FutureBuilder(
                                future: copyAsset(),
                                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                                  if (snapshot.hasData)
                                    return PDFViewerScaffold(
                                      appBar: AppBar(
                                        title: Text(textTranslation(ar: 'الشروط والاحكام', en: 'Policy')),
                                        centerTitle: true,
                                      ),
                                      path: snapshot.data.path,
                                    );
                                  return Container();
                                },
                              )),
                        ),
                      ),
                      Checkbox(
                        value: accepted,
                        onChanged: (b) {
                          _accepted.value = b;
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            SimpleButton(
              textTranslation(ar: 'ارسال الطلب', en: 'Send Request'),
              function: () async {
                int roleIndex = roleNames.indexWhere((test) => test == widget.role);
                if (currentUser.role.index != roleIndex && widget.formKey.currentState.validate() && _accepted.value)
                  loadingScreen(
                      context: context,
                      function: () async {
                        bool isVerified = (await isEmailVerified(context));
                        if (isVerified) {
                          await currentUser.getRequestedRole().then((onValue) async {
                            if (onValue['pending']) {
                              Navigator.of(context).pop();
                              CustomDialog(
                                  context: context,
                                  title: textTranslation(ar: 'خطأ', en: 'Error'),
                                  content: Text(
                                    textTranslation(
                                        ar: 'يوجد طلب سابق, لايمكنك تقديم طلب حالياُ',
                                        en: 'You can\'t send a new request, you already have one pending!'),
                                    textAlign: TextAlign.center,
                                  ),
                                  firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                                  firstButtonColor: Colors.black54,
                                  firstButtonFunction: () {
                                    Navigator.of(context).pop();
                                  });
                            } else {
                              await currentUser
                                  .requestRole(
                                role: UserRole.values[roleIndex],
                                inSaudi: widget.location == 'داخل السعودية',
                                idNumber: controller1.text.trim(),
                                bankInfo: controller2.text.trim(),
                              )
                                  .whenComplete(() {
                                Navigator.of(context).pop();
                                CustomDialog(
                                    context: context,
                                    title: textTranslation(ar: 'تم ارسال الطلب', en: 'Your request has been sent'),
                                    content: Text(
                                      textTranslation(
                                          ar: 'تم ارسال طلبك, الرجاء الانتظار من 24 ساعه الى 48 ساعه للرد على طلبك',
                                          en: ''),
                                      textAlign: TextAlign.center,
                                    ),
                                    firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                                    firstButtonColor: Colors.black54,
                                    firstButtonFunction: () {
                                      Navigator.of(context).pop();
                                    });
                              });
                            }
                          });
                        }
                      });
              },
            ),
          ],
        ),
      ),
    );
  }
}
