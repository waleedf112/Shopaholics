import 'package:flutter/material.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';

Future<bool> isEmailVerified(context, [bool pop = true]) async {
  bool isVerified = (await currentUser.isEmailVerified());
  if (!isVerified) {
    if (pop) Navigator.of(context).pop();
    return CustomDialog(
      context: context,
      title: 'خطأ',
      content: Text(
        'لم يتم تفعيل بريدك الالكتروني!' +
            '\n' +
            'تم ارسال رساله جديدة لتأكيد صحة بريدك.',
        textAlign: TextAlign.center,
      ),
      firstButtonText: 'حسناً',
      firstButtonColor: Colors.black54,
      firstButtonFunction: () {
        Navigator.of(context).pop(false);
      },
    );
  }
  return true;
}
