import 'package:flutter/material.dart';
import 'package:shopaholics/Functions/Translation.dart';

import 'dismissKeyboard.dart';

class SecondaryView extends StatelessWidget {
  String title;
  Widget child;
  Widget fab;
  Function backButtonFunction;
  bool disableBackButton;
  Function function;
  SecondaryView(
      {this.title = '', this.child, this.fab, this.backButtonFunction, this.disableBackButton = false, this.function});
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      function: function,
      child: WillPopScope(
        onWillPop: disableBackButton ? () {} : null,
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
      ),
    );
  }
}
