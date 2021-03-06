import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../Classes/User.dart';
import '../../../Functions/Translation.dart';
import '../../../Functions/isEmailVerified.dart';
import '../../../Widgets/AlertMessage.dart';
import '../../../Widgets/Button.dart';
import '../../../Widgets/CustomDialog.dart';
import '../../../Widgets/SecondaryView.dart';
import '../../../Widgets/TextWidget.dart';
import '../../../Widgets/loadingDialog.dart';
import '../Functions/Validators.dart';

class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController currentPasswordController = new TextEditingController(text: kDebugMode ? '12345678' : null);
    TextEditingController passwordController = new TextEditingController(text: kDebugMode ? '1234567899' : null);
    TextEditingController password2Controller = new TextEditingController(text: kDebugMode ? '1234567899' : null);
    TextEditingController phoneController =
        new TextEditingController(text: currentUser == null ? null : currentUser.phone);
    GlobalKey<FormState> formKey = new GlobalKey();
    return SecondaryView(
      title: textTranslation(ar: 'حسابي', en: 'My Account'),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              AlertMessage(
                message: textTranslation(
                    ar: 'الرجاء كتابة كلمة المرور الحالية قبل تغيير البيانات للتحقق من هويتك وحماية حسابك.',
                    en: 'Please type your current password before changing any information to verify your identity and secure your account.'),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: layoutTranslation(),
                  child: TextFormField(
                    textDirection: layoutTranslation(),
                    controller: currentPasswordController,
                    validator: (String value) => passwordValidation(value),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: textTranslation(ar: 'كلمة المرور الحالية', en: 'Current Password'),
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: layoutTranslation(),
                  child: TextFormField(
                    textDirection: TextDirection.ltr,
                    controller: phoneController,
                    keyboardType: TextInputType.numberWithOptions(),
                    validator: (String value) => phoneValidation(value),
                    decoration: InputDecoration(
                      labelText: textTranslation(ar: 'رقم الجوال', en: 'Phone Number'),
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: layoutTranslation(),
                  child: TextFormField(
                    textDirection: layoutTranslation(),
                    controller: passwordController,
                    validator: (String value) => passwordValidation(value, canBeEmpty: true),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: textTranslation(ar: 'كلمة المرور الجديدة', en: 'New Password'),
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              Container(
                height: 90,
                child: Directionality(
                  textDirection: layoutTranslation(),
                  child: TextFormField(
                    textDirection: layoutTranslation(),
                    controller: password2Controller,
                    validator: (String value) {
                      if (password2Controller.text != passwordController.text)
                        return textTranslation(ar: 'كلمات المرور غير متطابقة', en: 'Passwords don\'t match');
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: textTranslation(ar: 'أعد كلمة المرور الجديدة', en: 'Re-type New Password'),
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              SimpleButton(
                textTranslation(ar: 'حفظ البيانات', en: 'Save Information'),
                function: () async {
                  FocusScope.of(context).unfocus();
                  bool isVerified = (await isEmailVerified(context));
                  if (isVerified) {
                    if (formKey.currentState.validate()) {
                      loadingScreen(
                          context: context,
                          function: () async {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: currentUser.email, password: currentPasswordController.text)
                                .then((onValue) async {
                              if (passwordController.text.isNotEmpty) {
                                currentUser.resetPassword(passwordController.text);
                              }
                              await currentUser.updatePhoneNumber(phoneController.text);
                              Navigator.of(context).pop();
                              CustomDialog(
                                  context: context,
                                  title: textTranslation(ar: 'تم الحفظ', en: 'Saved'),
                                  content: TextWidget(textTranslation(
                                      ar: 'تم حفظ بياناتك بنجاح', en: 'Your new information has been saved')),
                                  firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
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
                                  title: textTranslation(ar: 'خطأ', en: 'Error'),
                                  content: TextWidget(onError.code == 'ERROR_TOO_MANY_REQUESTS'
                                      ? textTranslation(
                                          ar: 'تم تخطي عدد المحاولات المسموح بها, الرجاء المحاولة في وقت لاحق!',
                                          en: 'Maximum amount of tries has been reached, try again later')
                                      : textTranslation(
                                          ar: 'كلمة المرور الحالية خاطئه!', en: 'Your current passwords is invalid')),
                                  firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
                                  firstButtonColor: Colors.black45,
                                  firstButtonFunction: () {
                                    Navigator.of(context).pop();
                                  });
                            });
                          });
                    }
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
