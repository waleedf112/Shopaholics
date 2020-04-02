import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';

import 'Translation.dart';

Future<bool> isEmailVerified(context, [bool pop = true]) async {
  bool isVerified = (await currentUser.isEmailVerified());
  if (!isVerified && !kDebugMode) {
    if (pop) Navigator.of(context).pop();
    return CustomDialog(
      context: context,
      title: textTranslation(ar: 'خطأ', en: 'Error'),
      content: Text(
        textTranslation(ar:'لم يتم تفعيل بريدك الالكتروني!' + '\n' + 'تم ارسال رساله جديدة لتأكيد صحة بريدك.',en:'You haven\'t activated your email address.\nWe have sent you a new activation link.'),
        textAlign: TextAlign.center,
      ),
      firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
      firstButtonColor: Colors.black54,
      firstButtonFunction: () {
        Navigator.of(context).pop(false);
      },
    );
  }
  return true;
}
