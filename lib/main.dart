import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:persistent_bottom_nav_bar/utils/utils.dart';
import 'Classes/User.dart';
import 'Classes/UserRole.dart';
import 'Functions/PagePush.dart';
import 'Pages/Homepage/HomePage.dart';
import 'Pages/Settings/SigningPage.dart';
import 'Widgets/Button.dart';
import 'Widgets/MainView.dart';

const mapApi = 'AIzaSyBbG6iid8fXmD36E8eKIMJX9YVTE1gdyMI';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
    return MaterialApp(
      title: 'Shopaholics',
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
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.grey,
        cursorColor: Colors.grey, //Color(0xffd67e7e),
        primarySwatch: Colors.grey,
        textTheme: TextTheme(),
      ),
      home: Launcher(),
    );
  }
}

class Launcher extends StatefulWidget {
  bool firstRun;
  ValueNotifier<bool> isFirstLaunch = new ValueNotifier<bool>(null);
  Launcher({this.firstRun = true});
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  _init() async {
    if (widget.firstRun) {
      final appDocumentDir =
          await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
      Hive.registerAdapter(CurrentUserAdapter());
      Hive.registerAdapter(UserRoleAdapter());
      await Hive.openBox('currentUser');
      currentUser = await Hive.box('currentUser').get(0);
      try {
        await currentUser.updateData();
        print('====================');
        print(currentUser.role);
        print('====================');
      } catch (e) {}
      try {
        if (currentUser.role == null)
          await currentUser.requestRole(UserRole.customer, true);
      } catch (e) {}
    }

    if (await FirebaseAuth.instance.currentUser() == null) {
      currentUser = null;
      Hive.box('currentUser').delete(0);
    }
  }

  @override
  Future<void> initState() {
    super.initState();
    _init();

    Future.delayed(Duration(seconds: 1)).whenComplete(() async {
      await Hive.openBox('isFirstLaunch');
      if (Hive.box('isFirstLaunch').isEmpty) {
        await Hive.box('isFirstLaunch').put(0, true);
        widget.isFirstLaunch.value = true;
      } else {
        widget.isFirstLaunch.value = await Hive.box('isFirstLaunch').get(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 3,
              child: Image.asset(
                'assets/trans_logo.png',
                width: 200,
              )),
          Expanded(
            flex: 2,
            child: ValueListenableBuilder(
              valueListenable: widget.isFirstLaunch,
              builder:
                  (BuildContext context, bool isFirstLaunch, Widget child) {
                if (isFirstLaunch != null &&
                    widget.firstRun &&
                    widget.isFirstLaunch.value &&
                    !isSignedIn()) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SimpleButton(
                          'الدخول',
                          function: () => pushNewScreen(
                            context,
                            screen: SigningInPage(),
                            platformSpecific: false,
                            withNavBar: false,
                          ),
                        ),
                        SizedBox(height: 5),
                        SimpleButton(
                          'التسجيل',
                          function: () async => pushNewScreen(
                            context,
                            screen: SigningUpPage(),
                            platformSpecific: false,
                            withNavBar: false,
                          ),
                        ),
                        SizedBox(height: 5),
                        FlatButton(
                          onPressed: () {
                            Hive.box('isFirstLaunch').putAt(0, false);
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (cxt) {
                                  return MainView(
                                    child: HomePage(),
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            'التسجيل لاحقاً',
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  Future.delayed(Duration(seconds: 1)).whenComplete(() {
                    if (isFirstLaunch != null)
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                          builder: (cxt) {
                            return MainView(
                              child: HomePage(),
                            );
                          },
                        ),
                      );
                  });
                  return SpinKitRotatingCircle(
                    color: Colors.grey.withOpacity(0.2),
                    size: 50.0,
                  );
                }
/* 
return Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (cxt) {
            return MainView(
              child: HomePage(),
            );
          },
        ),
      );
*/
              },
            ),
          ),
        ],
      ),
    );
  }
}
