import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Functions/PagePush.dart';
import 'Pages/Homepage/HomePage.dart';
import 'Widgets/MainView.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          actionsIconTheme: IconThemeData(),
          color: Colors.white,
          elevation: 2,
          iconTheme: IconThemeData(),
          textTheme: TextTheme(
            title: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        backgroundColor: Colors.white,
        primaryColor: Colors.grey,
        cursorColor: Colors.grey, //Color(0xffd67e7e),
        primarySwatch: Colors.grey,
      ),
      home: Launcher(),
    );
  }
}

class Launcher extends StatefulWidget {
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).whenComplete(() => PagePush(
          context,
          MainView(
            child: HomePage(),
          ),
          replacement: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(flex: 3, child: Image.asset('assets/trans_logo.png')),
          Expanded(
            flex: 2,

            child: SpinKitRotatingCircle(
              
              color: Colors.grey.withOpacity(0.2),
              size: 50.0,
            ),
          )
        ],
      ),
    );
  }
}
