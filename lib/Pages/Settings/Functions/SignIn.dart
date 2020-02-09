import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'package:shopaholics/Widgets/CustomErrorDialog.dart';

Future<void> signInUser(context, {formKey, email, password}) async {
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
            error = onError.toString();
          }).then((value) {
            if (value is AuthResult) {
              userInit();
              currentUser.registerUser(value.user);
            }
            Navigator.of(context).pop();
          });
        });
  }
  if (error != null) {
    CustomErrorDialog(context, text: error);
  } else {
    Navigator.of(context).pop();
  }
}
