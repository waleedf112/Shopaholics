import 'package:flutter/material.dart';

import 'dismissKeyboard.dart';

class SecondaryView extends StatelessWidget {
  String title;
  Widget child;
  Widget fab;
  Function backButtonFunction;
  SecondaryView({this.title = '', this.child, this.fab, this.backButtonFunction});
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
              onPressed: () {
                if (backButtonFunction != null) backButtonFunction();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: child,
      ),
    );
  }
}
