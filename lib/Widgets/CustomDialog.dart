import 'package:flutter/material.dart';
import 'CustomButtonGradient.dart';

Future<bool> CustomDialog({
  @required BuildContext context,
  String title,
  @required Widget content,
  double titlePadding,
  bool dismissible,
  String firstButtonText,
  String secondButtonText,
  Color firstButtonColor,
  Color secondButtonColor,
  Function firstButtonFunction,
  Function secondButtonFunction,
  EdgeInsets contentPadding,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: dismissible ?? true,
    builder: (BuildContext context) {
      return Padding(
        padding: contentPadding ?? EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              elevation: 20,
              child: Column(
                children: <Widget>[
                  title != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(
                            titlePadding ?? 10,
                            titlePadding ?? 20,
                            titlePadding ?? 10,
                            titlePadding ?? 10,
                          ),
                          child: Text(
                            title,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(fontSize: 23),
                          ),
                        )
                      : Container(),
                  Divider(
                    color: Colors.grey.withOpacity(0.7),
                    height: contentPadding == null ? null : 0,
                  ),
                  Padding(
                      padding:
                          contentPadding ?? EdgeInsets.fromLTRB(8, 20, 8, 16),
                      child: Directionality(
                          textDirection: TextDirection.rtl, child: content)),
                  SizedBox(
                    height: contentPadding == null ? 20 : 0,
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (secondButtonText != null)
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: customGradient(
                                        secondButtonColor ??
                                            Theme.of(context).primaryColor,
                                        -12.0,
                                        -2.0,
                                        1.0),
                                  ),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      secondButtonText,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  )),
                                ),
                                Positioned.fill(
                                    child: new Material(
                                        color: Colors.transparent,
                                        child: new InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.2),
                                          highlightColor:
                                              Colors.white.withOpacity(0.1),
                                          onTap: secondButtonFunction,
                                        ))),
                              ],
                            ),
                          ),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  gradient: customGradient(
                                      firstButtonColor ??
                                          Theme.of(context).primaryColor,
                                      -12.0,
                                      -2.0,
                                      1.0),
                                ),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    firstButtonText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                )),
                              ),
                              Positioned.fill(
                                  child: new Material(
                                      color: Colors.transparent,
                                      child: new InkWell(
                                        splashColor:
                                            Colors.white.withOpacity(0.2),
                                        highlightColor:
                                            Colors.white.withOpacity(0.1),
                                        onTap: firstButtonFunction,
                                      ))),
                            ],
                          ),
                        )
                      ])
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
