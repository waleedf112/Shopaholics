import 'package:flutter/material.dart';

import 'CustomDialog.dart';

CustomErrorDialog(context, {text}) => CustomDialog(
      context: context,
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      dismissible: true,
      title: 'خطأ',
      firstButtonText: 'حسناً',
      firstButtonColor: Colors.black45,
      firstButtonFunction: () => Navigator.of(context).pop(),
    );
