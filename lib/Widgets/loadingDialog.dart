import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future loadingScreen({context, Function function}) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        function();
        return SpinKitRotatingCircle(
          color: Colors.white,
          size: 50.0,
        );
      });
}

Future loadingPopup({
  context,
  Function function,
  Function dialog,
}) async {
  return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        function();
        return SpinKitHourGlass(
          color: Colors.white,
          size: 50.0,
        );
      }).then((onValue) async {
    return await dialog(onValue);
  });
}
