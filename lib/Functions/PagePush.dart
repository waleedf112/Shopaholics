import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

PagePush(context, widget) {
  pushNewScreen(
    context,
    screen: widget,
    withNavBar: false,
  );
}
