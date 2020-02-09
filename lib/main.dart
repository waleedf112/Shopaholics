import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'Classes/User.dart';
import 'Functions/PagePush.dart';
import 'Pages/Homepage/HomePage.dart';
import 'Widgets/MainView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO fix status bar for ios
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
  @override
  Widget build(BuildContext context) {
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
  _init() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(CurrentUserAdapter());
    await Hive.openBox('currentUser');
    currentUser = Hive.box('currentUser').get(0);
    if (await FirebaseAuth.instance.currentUser() == null) {
      currentUser = null;
      Hive.box('currentUser').delete(0);
    }
  }

  @override
  Future<void> initState() {
    super.initState();
    _init();
    
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
          Expanded(
              flex: 3,
              child: Image.asset(
                'assets/trans_logo.png',
                width: 200,
              )),
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
