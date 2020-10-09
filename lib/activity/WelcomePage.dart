import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/src/providers/phone_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quizup/SessionManager/UserSessionNdata.dart';
import 'package:quizup/activity/home.dart';
import 'package:quizup/auth/name.dart';

// void main() => runApp(signIn());
class WelcomePage extends StatelessWidget {
  static String name = "/welcomepage";
  String myname;

  WelcomePage(String myname) {
    this.myname = myname;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _WelcomePage(myname == null
          ? ""
          : myname), // a random number, please don't call xD
    );
  }
}

class _WelcomePage extends StatefulWidget {
  String myname;

  _WelcomePage(this.myname);

  @override
  __WelcomePageState createState() => __WelcomePageState();
}

class __WelcomePageState extends State<_WelcomePage> {
  var onTapRecognizer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FittedBox(
                  fit: BoxFit.cover,
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                        fontSize: _size(), fontWeight: FontWeight.w500),
                  )),
              FittedBox(
                  fit: BoxFit.cover,
                  child:
                      Text(widget.myname+" a", style: TextStyle(fontSize: _size1(),fontWeight: FontWeight.w700)))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, abc);
  }

  double _size() {
    return MediaQuery.of(context).size.width * 0.08;
  }

  double _size1() {
    return MediaQuery.of(context).size.width * 0.12;
  }

  void abc() {
    setState(() {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => new home()));    });
  }
}
