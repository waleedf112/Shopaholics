import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Functions/isEmailVerified.dart';
import 'package:shopaholics/Widgets/AlertMessage.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/DropDownMenu.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

ValueNotifier<bool> _accepted = ValueNotifier<bool>(false);

class RolesPage extends StatefulWidget {
  String role = roleNames[currentUser.getRole()];
  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
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
      title: 'نوع الحساب',
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            AlertMessage(
              message: 'تقديم طلب على تغيير نوع الحساب لايعني الموافقة مباشرةً.' +
                  '\n' +
                  'سيتم الرد على طلبك من خلال 24 ساعة الى 48 ساعة.',
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
                  TextWidget('نوع الحساب:', minFontSize: 18, maxFontSize: 18),
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
                                pending ? roleNames[requestedRole] + ' (قيد التنفيذ)' : roleNames[currentRole],
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
                    child: TextWidget('تغيير نوع الحساب', minFontSize: 18, maxFontSize: 18),
                  ),
                  Expanded(
                    child: CustomDropDownMenu(
                      hint: 'اختر نوع الحساب',
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
            ValueListenableBuilder(
              valueListenable: _accepted,
              builder: (BuildContext context, bool accepted, Widget child) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        child: Text('قبول الشروط الاحكام, اضغط هنا لقراءة الشروط'),
                        onPressed: () => PagePush(
                            context,
                            FutureBuilder(
                              future: copyAsset(),
                              builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                                if (snapshot.hasData)
                                  return PDFViewerScaffold(
                                    appBar: AppBar(
                                      title: Text("الشروط والاحكام"),
                                      centerTitle: true,
                                    ),
                                    path: snapshot.data.path,
                                  );
                                return Container();
                              },
                            )),
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
              'ارسال الطلب',
              function: () async {
                int roleIndex = roleNames.indexWhere((test) => test == widget.role);
                if (currentUser.role.index != roleIndex && _accepted.value)
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
                                  title: 'خطأ',
                                  content: Text(
                                    'يوجد طلب سابق, لايمكنك تقديم طلب حالياُ',
                                    textAlign: TextAlign.center,
                                  ),
                                  firstButtonText: 'حسناً',
                                  firstButtonColor: Colors.black54,
                                  firstButtonFunction: () {
                                    Navigator.of(context).pop();
                                  });
                            } else {
                              await currentUser.requestRole(UserRole.values[roleIndex]).whenComplete(() {
                                Navigator.of(context).pop();
                                CustomDialog(
                                    context: context,
                                    title: 'تم ارسال الطلب',
                                    content: Text(
                                      'تم ارسال طلبك, الرجاء الانتظار من 24 ساعه الى 48 ساعه للرد على طلبك',
                                      textAlign: TextAlign.center,
                                    ),
                                    firstButtonText: 'حسناً',
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
