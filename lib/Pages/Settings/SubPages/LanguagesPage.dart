import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../Functions/AppLanguage.dart';
import '../../../Functions/Translation.dart';
import '../../../Widgets/AlertMessage.dart';
import '../../../Widgets/Button.dart';
import '../../../Widgets/CustomDialog.dart';
import '../../../Widgets/SecondaryView.dart';

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
      title: textTranslation(ar: 'لغة البرنامج', en: 'App Language'),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AlertMessage(
              message: textTranslation(ar: 'سيتم تغيير لغة البرنامج بعد تشغيل البرنامج مرة اخرى!', en: 'The language will change after the app restarts.'),
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
            child: SimpleButton(textTranslation(ar: 'تغيير اللغة', en: 'Change Language'), function: () {
              setCurrentAppLanguage(widget.languageValue);
              CustomDialog(
                  context: context,
                  title: textTranslation(ar: 'تم', en: 'Done'),
                  content: AutoSizeText(
                    textTranslation(ar: 'تم تغيير اللغة بنجاح!\n', en: 'App Language saved') +
                        textTranslation(ar: 'سيتم اجراء التغيير بعد تشغيل البرنامج مرة اخرى.', en: 'The language will change after the app restarts.'),
                    textAlign: TextAlign.center,
                  ),
                  dismissible: false,
                  firstButtonColor: Colors.black45,
                  firstButtonText: textTranslation(ar: 'حسناً', en: 'OK'),
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
