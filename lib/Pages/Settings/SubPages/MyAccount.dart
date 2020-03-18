import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Pages/Settings/Functions/Validators.dart';
import 'package:shopaholics/Widgets/AlertMessage.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/dismissKeyboard.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';

class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //TODO currentUser.saveUserChanges()

    TextEditingController currentPasswordController =
        new TextEditingController(text: kDebugMode ? '12345678' : null);
    TextEditingController passwordController =
        new TextEditingController(text: kDebugMode ? '1234567899' : null);
    TextEditingController password2Controller =
        new TextEditingController(text: kDebugMode ? '1234567899' : null);
    TextEditingController phoneController = new TextEditingController(
        text: currentUser == null ? null : currentUser.phone);
    TextEditingController displayNameController = new TextEditingController(
        text: currentUser == null ? null : currentUser.displayName);
    GlobalKey<FormState> formKey = new GlobalKey();
    return SecondaryView(
      title: 'حسابي',
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              AlertMessage(
                message:
                    'عند تغيير الاسم, يجب عليك الانتظار بعض الوقت لظهور الاسم الجديد.\n' +
                        'الرجاء كتابة كلمة المرور الحالية قبل تغيير البيانات للتحقق من هويتك وحماية حسابك.',
                maxLines: 3,
              ),
              SizedBox(height: 12),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: currentPasswordController,
                    validator: (String value) => passwordValidation(value),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الحالية',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: displayNameController,
                    validator: (String value) => nameValidation(value),
                    decoration: InputDecoration(
                      labelText: 'الاسم',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    controller: phoneController,
                    keyboardType: TextInputType.numberWithOptions(),
                    validator: (String value) => phoneValidation(value),
                    decoration: InputDecoration(
                      labelText: 'رقم الجوال',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: passwordController,
                    validator: (String value) =>
                        passwordValidation(value, canBeEmpty: true),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور الجديدة',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    controller: password2Controller,
                    validator: (String value) {
                      if (password2Controller.text != passwordController.text)
                        return 'كلمات المرور غير متطابقة';
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'أعد كلمة المرور الجديدة',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              SimpleButton(
                'حفظ البيانات',
                function: () async {
                  FocusScope.of(context).unfocus();

                  if (formKey.currentState.validate()) {
                    loadingScreen(
                        context: context,
                        function: () async {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: currentUser.email,
                                  password: currentPasswordController.text)
                              .then((onValue) async {
                            if (passwordController.text.isNotEmpty) {
                              currentUser
                                  .resetPassword(passwordController.text);
                            }
                            await currentUser
                                .updatePhoneNumber(phoneController.text);
                            Navigator.of(context).pop();
                            CustomDialog(
                                context: context,
                                title: 'تم الحفظ',
                                content: TextWidget('تم حفظ بياناتك بنجاح'),
                                firstButtonText: 'حسناً',
                                firstButtonColor: Colors.black45,
                                firstButtonFunction: () {
                                  onValue.user.reload();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                });
                          }).catchError((onError) {
                            print('error: $onError');
                            Navigator.of(context).pop();
                            CustomDialog(
                                context: context,
                                title: 'خطأ',
                                content: TextWidget(onError.code ==
                                        'ERROR_TOO_MANY_REQUESTS'
                                    ? 'تم تخطي عدد المحاولات المسموح بها, الرجاء المحاولة في وقت لاحق!'
                                    : 'كلمة المرور الحالية خاطئه!'),
                                firstButtonText: 'حسناً',
                                firstButtonColor: Colors.black45,
                                firstButtonFunction: () {
                                  Navigator.of(context).pop();
                                });
                          });
                          /* await currentUser.resetPassword(passwordController.text).whenComplete((){
                        Navigator.of(context).pop();
                      }); */
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
