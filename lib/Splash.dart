import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizup/SessionManager/UserSessionNdata.dart';
import 'package:quizup/activity/home.dart';
import 'package:quizup/auth/Login.dart';
import 'package:quizup/auth/signIn.dart';

import 'TodaysQuiz/TodayQuizUp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/splash': (BuildContext context) => new SplashScreen(),
      home.name: (BuildContext context) => new home(),
      Login.name: (BuildContext context) => new Login(),
      TodayQuizUp.name: (BuildContext context) => new TodayQuizUp(),
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
        print("data ${data.toString()}");
        Navigator.of(context).pushReplacementNamed(home.name);

        // Navigator.push(/
        //     context, MaterialPageRoute(builder: (scaffoldContext) => home()));
      } else {
        print("data ${data.toString()}");
        Navigator.of(context).pushReplacementNamed(Login.name);

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (scaffoldContext) => Login()));
      }
    }, onError: (e) {
      print("data ${e.toString()}");
      Navigator.of(context).pushReplacementNamed(Login.name);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (scaffoldContext) => Login()));
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
