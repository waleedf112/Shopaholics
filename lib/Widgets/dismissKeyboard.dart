import 'package:flutter/material.dart';

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  DismissKeyboard({this.child});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
