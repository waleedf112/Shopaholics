import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingStreamBuilder extends StatelessWidget {
  Widget widget;
  bool loading;
  bool hasData;
  LoadingStreamBuilder({
    @required this.widget,
    @required this.loading,
    @required this.hasData,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: SpinKitRotatingCircle(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        secondChild: loading ? Container() : widget,
        crossFadeState:
            hasData ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: Duration(milliseconds: 200));
  }
}
