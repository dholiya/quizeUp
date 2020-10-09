import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizup/SessionManager/UserSessionNdata.dart';
import 'package:quizup/activity/WelcomePage.dart';
import 'package:quizup/activity/home.dart';
import 'package:quizup/auth/Login.dart';
import 'package:quizup/auth/otpPage.dart';

import 'TodaysQuiz/TodayQuizUp.dart';
import 'auth/name.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/splash': (BuildContext context) => SplashScreen(),
      home.name: (BuildContext context) => home(),
      Login.name: (BuildContext context) => Login(),
      TodayQuizUp.name: (BuildContext context) => TodayQuizUp(),
      WelcomePage.name: (BuildContext context) => WelcomePage(""),
      enterName.name: (BuildContext context) => enterName(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    Session prefs = Session();

    Future<bool> authToken = prefs.getAuthToken();
    authToken.then((data) {
      if (data == true) {
        Future<String> authName = prefs.getName();
        authName.then((value) => {
              if (value == null || value == "")
                {
                  print("authName $value"),
                  Navigator.of(context).pushReplacementNamed(enterName.name)
                }
              else
                {
                  print("authName $value"),
                  Navigator.of(context).pushReplacementNamed(home.name)
                }
            });
      } else {
        print("data ${data.toString()}");
        Navigator.of(context).pushReplacementNamed(Login.name);
      }
    }, onError: (e) {
      print("data ${e.toString()}");
      Navigator.of(context).pushReplacementNamed(Login.name);
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('assets/images/google_log.png'),
      ),
    );
  }
}
