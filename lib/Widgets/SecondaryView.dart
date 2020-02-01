import 'package:flutter/material.dart';

class SecondaryView extends StatelessWidget {
  String title;
  Widget child;
  SecondaryView({this.title = '', this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: child,
    );
  }
}
