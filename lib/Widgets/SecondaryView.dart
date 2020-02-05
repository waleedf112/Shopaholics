import 'package:flutter/material.dart';

import 'dismissKeyboard.dart';

class SecondaryView extends StatelessWidget {
  String title;
  Widget child;
  Widget fab;
  SecondaryView({this.title = '', this.child,this.fab});
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
          child: Scaffold(
            floatingActionButton: fab,
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
      ),
    );
  }
}
