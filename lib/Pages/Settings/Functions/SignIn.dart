import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../Classes/User.dart';
import '../../../Functions/passwordExceptions.dart';
import '../../../Widgets/CustomErrorDialog.dart';
import '../../../Widgets/loadingDialog.dart';
import '../../../main.dart';

Future<void> signInUser(context, {@required GlobalKey<FormState> formKey, email, password}) async {
  FocusScope.of(context).unfocus();
  String error;
  if (formKey.currentState.validate()) {
    await loadingScreen(
        context: context,
        function: () async {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          )
              .catchError((onError) {
            error = onError.code.toString();
          }).then((value) async {
            if (value is AuthResult) {
              userInit();
              await currentUser.registerUser(value.user);
            }
            Navigator.of(context).pop();
          });
        });
  }
  if (error != null) {
    CustomErrorDialog(context, text: exceptionLoginRegister(error));
  } else {
    Hive.box('isFirstLaunch').putAt(0, false);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (cxt) {
      return Launcher(firstRun: false);
    }));
  }
}
