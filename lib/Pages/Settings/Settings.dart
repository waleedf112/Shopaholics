import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/dismissKeyboard.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Widgets/Button.dart';

import 'Functions/Validators.dart';
import 'Functions/SignUp.dart';
import 'Functions/SignIn.dart';

class SettingsPage extends StatelessWidget {
  GlobalKey<FormState> formKey = new GlobalKey();

  TextEditingController emailController = new TextEditingController(text: kDebugMode ? 'a@a.aa' : null);
  TextEditingController passwordController = new TextEditingController(text: kDebugMode ? '12345678' : null);
  TextEditingController displayNameController =
      new TextEditingController(text: currentUser == null ? null : currentUser.displayName);

  Widget setting({String title, String desc, IconData icon, Function onPressed}) {
    return Container(
      color: onPressed == null ? Colors.grey.withOpacity(0.3) : Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            textDirection: TextDirection.rtl,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black54,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    TextWidget(title),
                    TextWidget(desc, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingSection(List<Widget> list) {
    return Card(
      shape: Border(),
      elevation: 3,
      margin: EdgeInsets.all(0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, int index) => Divider(
          height: 0,
          color: Colors.grey,
        ),
        itemBuilder: (context, int index) => list[index],
      ),
    );
  }

  Widget topWidget(context) {
    if (isSignedIn()) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          textDirection: TextDirection.rtl,
          children: <Widget>[
            Opacity(
              opacity: 0.3,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/default_avatar.png'),
                backgroundColor: Colors.white,
                radius: 30,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  textDirection: TextDirection.rtl,
                  controller: displayNameController,
                  decoration: InputDecoration(
                    filled: true,
                  ),
                  onChanged: (String name) {
                    if (name.trim().isNotEmpty) {
                      currentUser.setName(name.trim());
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return settingSection([
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Form(
          key: formKey,
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
                      labelText: 'البريد الالكتروني',
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
                      labelText: 'كلمة المرور',
                      labelStyle: TextStyle(fontSize: 14),
                      filled: true,
                    ),
                  ),
                ),
              ),
              SimpleButton(
                'الدخول',
                function: () async => await signInUser(
                  context,
                  formKey: formKey,
                  email: emailController,
                  password: passwordController,
                ),
              ),
              SizedBox(height: 5),
              SimpleButton(
                'التسجيل',
                function: () async => await signUpUser(
                  context,
                  formKey: formKey,
                  email: emailController,
                  password: passwordController,
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    //TODO currentUser.saveUserChanges()
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        topWidget(context),
        SizedBox(height: 25),
        if (isSignedIn())
          settingSection([
            setting(
              title: 'حسابي',
              desc: 'لادارة حسابك وتغيير البريد الالكتروني وكلمة المرور',
              icon: Icons.lock,
            ),
            setting(
                title: 'تسجيل خروج',
                desc: 'لتسجيل الخروج من حسابك',
                icon: Icons.subdirectory_arrow_right,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  String error;

                  await loadingScreen(
                      context: context,
                      function: () async {
                        await FirebaseAuth.instance.signOut().catchError((onError) {
                          error = onError.toString();
                        });
                        if (error == null) userDelete();
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
                      title: 'خطأ',
                      firstButtonText: 'حسناً',
                      firstButtonColor: Colors.black45,
                      firstButtonFunction: () => Navigator.of(context).pop(),
                    );
                  } else {
                   // Navigator.of(context).pop();
                  }
                }),
          ]),
        if (isSignedIn()) SizedBox(height: 25),
        if (isSignedIn())
          settingSection([
            setting(
              title: 'الطلبات',
              desc: 'لعرض طلباتك الحاليه والسابقة',
              icon: Icons.shopping_basket,
            ),
            setting(
              title: 'عناوين التوصيل',
              desc: 'تحديد عناوينك لتوصيل الطلبات',
              icon: Icons.location_on,
            ),
            setting(
              title: 'وسائل الدفع',
              desc: 'اضافة وحذف أي وسيلة للدفع',
              icon: Icons.credit_card,
            ),
            setting(
              title: 'التسجيل كبائع',
              desc: 'لتقديم طلب صلاحيه البيع في التطبيق',
              icon: Icons.store_mall_directory,
            ),
          ]),
        if (isSignedIn()) SizedBox(height: 25),
        settingSection([
          setting(
            title: 'التنبيهات',
            desc: 'اعدادات التنبيهات للتخفيضات والعروض وغيرها',
            icon: Icons.notifications_active,
          ),
          setting(
            title: 'اللغة',
            desc: 'تغيير لغة عرض البرنامج',
            icon: Icons.language,
          ),
          setting(
            title: 'اتصل بنا',
            desc: 'للتواصل مع ادارة التطبيق وللشكاوي والاقتراحات',
            icon: Icons.message,
          ),
        ]),
      ],
    );
  }
}
