import 'package:flutter/material.dart';

import '../Functions/Translation.dart';
import 'CustomDialog.dart';

CustomErrorDialog(context, {text}) => CustomDialog(
      context: context,
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      dismissible: true,
      title: textTranslation(ar: 'خطأ', en: 'Error'),
      firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
      firstButtonColor: Colors.black45,
      firstButtonFunction: () => Navigator.of(context).pop(),
    );
