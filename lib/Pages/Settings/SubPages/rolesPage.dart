import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Widgets/AlertMessage.dart';
import 'package:shopaholics/Widgets/DropDownMenu.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';

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
            //TODO change the duration in the text.
            AlertMessage(
              message: 'تقديم طلب على تغيير نوع الحساب لايعني الموافقة مباشرةً.' +
                  '\n' +
                  'سيتم الرد على طلبك خلال 1 دقيقة الى 3 دقائق.',
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
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        TextWidget('ادمن', minFontSize: 15, maxFontSize: 15),
                        SizedBox(width: 5),
                        Icon(
                          Icons.check_circle,
                          size: 15,
                          color: Colors.green[500],
                        ),
                      ],
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
          ],
        ),
      ),
    );
  }
}
