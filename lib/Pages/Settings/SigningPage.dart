import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';

import '../../Classes/User.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/CustomDialog.dart';
import '../../Widgets/SecondaryView.dart';
import '../../main.dart';
import 'Functions/SignIn.dart';
import 'Functions/SignUp.dart';
import 'Functions/Validators.dart';

class SigningInPage extends StatelessWidget {
  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController emailController = new TextEditingController(text: kDebugMode ? 'a@a.aa' : null);
  TextEditingController passwordController = new TextEditingController(text: kDebugMode ? '12345678' : null);

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      child: Form(
        key: formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Image.asset(
              'assets/trans_logo.png',
              width: 150,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        controller: emailController,
                        validator: (String value) => emailValidation(value),
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'البريد الالكتروني', en: 'Email'),
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
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'كلمة المرور', en: 'Password'),
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  //TODO forget password bustton
                  /* FlatButton(child: Text('نسيت كلمة المرور',style: TextStyle(color: Colors.blueAccent),), onPressed: () {}),
                  SizedBox(height: 5), */
                  SimpleButton(
                    textTranslation(ar: 'الدخول', en: 'Sign in'),
                    function: () async => await signInUser(context,
                        email: emailController, password: passwordController, formKey: formKey),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SigningUpPage extends StatelessWidget {
  GlobalKey<FormState> formKey = new GlobalKey();
  TextEditingController emailController = new TextEditingController(text: kDebugMode ? 'a@a.aa' : null);
  TextEditingController nameController = new TextEditingController(text: kDebugMode ? 'وليد' : null);
  TextEditingController phoneController = new TextEditingController(text: kDebugMode ? '0500000000' : null);
  TextEditingController passwordController = new TextEditingController(text: kDebugMode ? '12345678' : null);
  TextEditingController password2Controller = new TextEditingController(text: kDebugMode ? '12345678' : null);

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      child: Form(
        key: formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Image.asset(
              'assets/trans_logo.png',
              width: 150,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        textDirection: TextDirection.ltr,
                        controller: nameController,
                        validator: (String value) => nameValidation(value),
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'الاسم', en: ''),
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
                          labelText: textTranslation(ar: 'رقم الجوال', en: ''),
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
                        controller: emailController,
                        validator: (String value) => emailValidation(value),
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'البريد الالكتروني', en: 'Email'),
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
                        controller: passwordController,
                        validator: (String value) => passwordValidation(value),
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'كلمة المرور', en: 'Password'),
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
                        controller: password2Controller,
                        validator: (String value) {
                          if (password2Controller.text != passwordController.text)
                            return textTranslation(ar: 'كلمات المرور غير متطابقة', en: '');
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: textTranslation(ar: 'أعد كلمة المرور', en: ''),
                          labelStyle: TextStyle(fontSize: 14),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                  SimpleButton(
                    textTranslation(ar: 'التسجيل', en: 'Register'),
                    function: () async => await signUpUser(context,
                        email: emailController,
                        password: passwordController,
                        formKey: formKey,
                        name: nameController.text,
                        phone: phoneController.text),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SigningOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String error;

    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      await FirebaseAuth.instance.signOut().catchError((onError) {
        error = onError.toString();
        if (error == null) userDelete();
        print('here 1');
      }).then((onValue) {
        Navigator.of(context).pop();
      });
      if (error != null) {
        CustomDialog(
          context: context,
          content: Text(
            error,
            textAlign: TextAlign.center,
          ),
          dismissible: true,
          title: textTranslation(ar: 'خطأ', en: 'Error'),
          firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
          firstButtonColor: Colors.black45,
          firstButtonFunction: () => Navigator.of(context).pop(),
        );
      } else {
        print('here 5');
        pushNewScreen(
          context,
          screen: Launcher(firstRun: false),
          platformSpecific: true,
          withNavBar: false,
        );
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (cxt) {
          return Launcher(firstRun: false);
        }));
      }
    });

    return Scaffold(
      body: Center(
          child: SpinKitRotatingCircle(
        color: Colors.grey.withOpacity(0.2),
        size: 50.0,
      )),
    );
  }
}
