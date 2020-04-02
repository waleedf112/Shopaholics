import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/AppLanguage.dart';
import 'package:shopaholics/Widgets/AlertMessage.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';

class LanguagesPage extends StatefulWidget {
  AppLanguage languageValue;
  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  @override
  void initState() {
    widget.languageValue = currentAppLanguage;
    super.initState();
  }

  void _setLanguage(AppLanguage language) => setState(() => widget.languageValue = language);

  @override
  Widget build(BuildContext context) {
    return SecondaryView(
      title: 'لغة البرنامج',
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AlertMessage(
              message: 'سيتم تغيير لغة البرنامج بعد تشغيل البرنامج مرة اخرى!',
              color: Colors.black26,
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    value: AppLanguage.arabic,
                    groupValue: widget.languageValue,
                    title: Text('العربية'),
                    onChanged: (AppLanguage i) => _setLanguage(i),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: AppLanguage.english,
                    groupValue: widget.languageValue,
                    title: Text('English'),
                    onChanged: (AppLanguage i) => _setLanguage(i),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
            child: SimpleButton('تغيير اللغة', function: () {
              setCurrentAppLanguage(widget.languageValue);
              CustomDialog(
                  context: context,
                  title: 'تم',
                  content: AutoSizeText(
                    'تم تغيير اللغة بنجاح!\n' + 'سيتم اجراء التغيير بعد تشغيل البرنامج مرة اخرى.',
                    textAlign: TextAlign.center,
                  ),
                  dismissible: false,
                  firstButtonColor: Colors.black45,
                  firstButtonText: 'حسناً',
                  firstButtonFunction: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
            }),
          ),
        ],
      ),
    );
  }
}
