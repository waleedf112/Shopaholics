import 'package:flutter/cupertino.dart';

PagePush(context, widget, {replacement = false}) {
  var route = CupertinoPageRoute(builder: (ctx) {
    return widget;
  });
  if (replacement) {
    Navigator.of(context).pushReplacement(route);
  } else {
    Navigator.of(context).push(route);
  }
}
