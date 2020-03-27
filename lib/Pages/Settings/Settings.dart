import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';
import 'package:shopaholics/Classes/User.dart';
import 'package:shopaholics/Classes/UserRole.dart';
import 'package:shopaholics/Functions/PagePush.dart';
import 'package:shopaholics/Widgets/CustomDialog.dart';
import 'package:shopaholics/Widgets/SecondaryView.dart';
import 'package:shopaholics/Widgets/TextWidget.dart';
import 'package:shopaholics/Widgets/dismissKeyboard.dart';
import 'package:shopaholics/Widgets/loadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:shopaholics/Widgets/Button.dart';
import 'package:shopaholics/Widgets/testPage.dart';
import '../../main.dart';
import 'Functions/Validators.dart';
import 'Functions/SignUp.dart';
import 'Functions/SignIn.dart';
import 'SigningPage.dart';
import 'SubPages/Addresses.dart';
import 'SubPages/MyAccount.dart';
import 'SubPages/MyOrders.dart';
import 'SubPages/RolesRequestsPage.dart';
import 'SubPages/rolesPage.dart';
import 'SubPages/salesPage.dart';

class SettingsPage extends StatelessWidget {
  Widget setting(
      {String title, String desc, IconData icon, Function onPressed}) {
    return Container(
      color:
          onPressed == null ? Colors.grey.withOpacity(0.3) : Colors.transparent,
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
                    TextWidget(desc,
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
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
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextWidget(currentUser.displayName,
                    style: TextStyle(fontSize: 18)),
                TextWidget(currentUser.email,
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )
          ],
        ),
      );
    }
    return settingSection([
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            SimpleButton(
              'الدخول',
              function: () => pushNewScreen(
                context,
                screen: SigningInPage(),
                platformSpecific: false,
                withNavBar: false,
              ),
            ),
            SizedBox(height: 5),
            SimpleButton(
              'التسجيل',
              function: () async => pushNewScreen(
                context,
                screen: SigningUpPage(),
                platformSpecific: false,
                withNavBar: false,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        topWidget(context),
        SizedBox(height: 25),
        if (isSignedIn())
          settingSection([
            if (kDebugMode)
              setting(
                  title: 'testing',
                  desc: '',
                  icon: Icons.lock,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    PagePush(context, TestPage());
                  }),
            setting(
                title: 'حسابي',
                desc: 'لادارة حسابك وتغيير البريد الالكتروني وكلمة المرور',
                icon: Icons.lock,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  PagePush(context, MyAccountPage());
                }),
            setting(
                title: 'تسجيل خروج',
                desc: 'لتسجيل الخروج من حسابك',
                icon: Icons.subdirectory_arrow_right,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  pushNewScreen(
                    context,
                    screen: SigningOutPage(),
                    platformSpecific: false,
                    withNavBar: false,
                  );
                }),
          ]),
        if (isSignedIn()) SizedBox(height: 25),
        if (isSignedIn())
          settingSection([
            setting(
              title: 'المبيعات',
              desc: 'لعرض المبيعات وتحديث حاله كل شحنة',
              icon: Icons.monetization_on,
              onPressed: () => PagePush(context, SalesPage()),
            ),
            setting(
              title: 'طلباتي',
              desc: 'لعرض طلباتك الحاليه والسابقة',
              icon: Icons.shopping_basket,
              onPressed: () => PagePush(context, MyOrdersPage()),
            ),
            setting(
              title: 'عنوان التوصيل',
              desc: 'تحديد عنوانك لتوصيل الطلبات',
              icon: Icons.location_on,
              onPressed: () => PagePush(context, AddressesPage()),
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
              onPressed: () => PagePush(context, RolesPage()),
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
        SizedBox(height: 25),
        if (isSignedIn() && currentUser.role == UserRole.admin)
          settingSection([
            setting(
              title: 'طلبات المستخدمين',
              desc: 'عرض طلبات المستخدمين للتسجيل كبائع وغيرها',
              icon: Icons.present_to_all,
              onPressed: () => PagePush(context, RolesRequestsPage()),
            ),
            setting(
              title: 'البلاغات',
              desc: 'البلاغات عن المنتجات والطلبات والمستخدمين والشكاوى',
              icon: Icons.warning,
            ),
            setting(
              title: 'التصانيف والاقسام',
              desc: 'تعديل واضافة اقسام للمنتجات',
              icon: Icons.menu,
            ),
          ]),
        SizedBox(height: 25),
      ],
    );
  }
}
