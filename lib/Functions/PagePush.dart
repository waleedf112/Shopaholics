import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

PagePush(context, widget, [navBar = false]) {
  pushNewScreen(
    context,
    screen: widget,
    withNavBar: navBar,
  );
}
