import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mdi/mdi.dart';
import 'package:persistent_bottom_nav_bar/utils/utils.dart';

import '../../Classes/User.dart';
import '../../Classes/UserRole.dart';
import '../../Functions/PagePush.dart';
import '../../Functions/Translation.dart';
import '../../Widgets/Button.dart';
import '../../Widgets/TextWidget.dart';
import '../TicketsPages/TicketViewer.dart';
import 'SigningPage.dart';
import 'SubPages/Addresses.dart';
import 'SubPages/LanguagesPage.dart';
import 'SubPages/MyAccount.dart';
import 'SubPages/MyOrders.dart';
import 'SubPages/MyProducts.dart';
import 'SubPages/PaymentPage.dart';
import 'SubPages/RolesRequestsPage.dart';
import 'SubPages/rolesPage.dart';
import 'SubPages/salesPage.dart';

class SettingsPage extends StatelessWidget {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
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
                    TextWidget(currentUser.displayName, style: TextStyle(fontSize: 18)),
                    TextWidget(currentUser.email, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            if (currentUser.role != UserRole.customer)
              FutureBuilder(
                future: Firestore.instance.collection('Users').document(currentUser.uid).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return SpinKitRotatingCircle(
                      color: Colors.grey.withOpacity(0.2),
                      size: 30,
                    );
                  return Column(
                    children: <Widget>[
                      Icon(
                        Icons.star_border,
                        size: 30,
                        color: Colors.green[700].withOpacity(0.7),
                      ),
                      Text(
                        snapshot.data.data['rating'].toDouble().toStringAsFixed(2),
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  );
                },
              ),
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
              textTranslation(ar: 'الدخول', en: ''),
              function: () => pushNewScreen(
                context,
                screen: SigningInPage(),
                platformSpecific: false,
                withNavBar: false,
              ),
            ),
            SizedBox(height: 5),
            SimpleButton(
              textTranslation(ar: 'التسجيل', en: ''),
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
            setting(
                title: textTranslation(ar: 'حسابي', en: ''),
                desc: textTranslation(ar: 'لادارة حسابك وتغيير البريد الالكتروني وكلمة المرور', en: ''),
                icon: Icons.lock,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  PagePush(context, MyAccountPage());
                }),
            setting(
                title: textTranslation(ar: 'تسجيل خروج', en: ''),
                desc: textTranslation(ar: 'لتسجيل الخروج من حسابك', en: ''),
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
            setting(
              title: textTranslation(ar: 'اللغة', en: ''),
              desc: textTranslation(ar: 'تغيير لغة عرض البرنامج', en: ''),
              icon: Icons.language,
              onPressed: () => PagePush(context, LanguagesPage()),
            ),
          ]),
        if (isSignedIn()) SizedBox(height: 25),
        if (isSignedIn())
          settingSection([
            if (currentUser.role != UserRole.customer)
              setting(
                title: textTranslation(ar: 'منتجاتي', en: ''),
                desc: textTranslation(ar: 'عرض جميع منتجاتك وادارتها', en: ''),
                icon: Mdi.packageVariantClosed,
                onPressed: () => PagePush(context, MyProductsPage()),
              ),
            if (currentUser.role != UserRole.customer)
              setting(
                title: textTranslation(ar: 'المبيعات', en: ''),
                desc: textTranslation(ar: 'لعرض المبيعات وتحديث حاله كل شحنة', en: ''),
                icon: Icons.monetization_on,
                onPressed: () => PagePush(context, SalesPage()),
              ),
            setting(
              title: textTranslation(ar: 'طلباتي', en: ''),
              desc: textTranslation(ar: 'لعرض طلباتك الحاليه والسابقة', en: ''),
              icon: Icons.shopping_basket,
              onPressed: () => PagePush(context, MyOrdersPage()),
            ),
            setting(
              title: textTranslation(ar: 'عنوان التوصيل', en: ''),
              desc: textTranslation(ar: 'تحديد عنوانك لتوصيل الطلبات', en: ''),
              icon: Icons.location_on,
              onPressed: () => PagePush(context, AddressesPage()),
            ),
            setting(
              title: textTranslation(ar: 'وسيلة الدفع', en: ''),
              desc: textTranslation(ar: 'اضافة او تعديل بيانات وسيلة الدفع', en: ''),
              icon: Icons.credit_card,
              onPressed: () => PagePush(context, PaymentPage()),
            ),
            setting(
              title: textTranslation(ar: 'التسجيل كبائع', en: ''),
              desc: textTranslation(ar: 'لتقديم طلب صلاحيه البيع في التطبيق', en: ''),
              icon: Icons.store_mall_directory,
              onPressed: () => PagePush(context, RolesPage()),
            ),
          ]),
        SizedBox(height: 25),
        if (isSignedIn() && currentUser.role == UserRole.admin)
          settingSection([
            setting(
              title: textTranslation(ar: 'طلبات المستخدمين', en: ''),
              desc: textTranslation(ar: 'عرض طلبات المستخدمين للتسجيل كبائع وغيرها', en: ''),
              icon: Icons.present_to_all,
              onPressed: () => PagePush(context, RolesRequestsPage()),
            ),
            setting(
              title: textTranslation(ar: 'البلاغات', en: ''),
              desc: textTranslation(ar: 'البلاغات عن المنتجات والطلبات والمستخدمين والشكاوى', en: ''),
              icon: Icons.warning,
              onPressed: () => PagePush(context, TicketsViewer()),
            ),
          ]),
        SizedBox(height: 25),
      ],
    );
  }
}
