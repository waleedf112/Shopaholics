import 'package:flutter/material.dart';

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  Function function;
  DismissKeyboard({this.child, this.function});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (function != null) function();
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
