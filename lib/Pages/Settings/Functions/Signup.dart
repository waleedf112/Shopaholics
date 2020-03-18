import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Functions/passwordExceptions.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'package:shopaholics/Widgets/CustomErrorDialog.dart';

import '../../../main.dart';

Future<void> signUpUser(context,
    {formKey, email, password, String name, String phone}) async {
  FocusScope.of(context).unfocus();
  String error;
  if (formKey.currentState.validate()) {
    await loadingScreen(
        context: context,
        function: () async {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          )
              .catchError((onError) {
            error = onError.code.toString();
          }).then((value) async {
            if (value is AuthResult) {
              userInit();
              await currentUser.registerUser(value.user, name, phone);
            }
            Navigator.of(context).pop();
          });
        });
        if (error != null) {
    CustomErrorDialog(context, text: exceptionLoginRegister(error));
  } else {
    Navigator.of(context).pop();

    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (cxt) {
      return Launcher(firstRun: false);
    }));
  }
  }
  
}
