import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Widgets/AlertMessage.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/DropDownMenu.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';

class RolesPage extends StatefulWidget {
  String role = roleNames[currentUser.getRole()];

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
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
            SizedBox(height: 30),
            SimpleButton(
              'ارسال الطلب',
              function: () async {
                int roleIndex = roleNames.indexWhere((test) => test == widget.role);
                loadingScreen(
                    context: context,
                    function: () async {
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
                      /*   */
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
