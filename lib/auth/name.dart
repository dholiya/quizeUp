import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizup/SessionManager/UserSessionNdata.dart';
import 'package:quizup/activity/home.dart';

class enterName extends StatefulWidget {
  static String name = "/enterName";

  @override
  _enterNameState createState() => new _enterNameState();
}

class _enterNameState extends State<enterName> with TickerProviderStateMixin {
  TextEditingController textFormFieldcon = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _globalKey = new GlobalKey();
  Animation _animation;
  AnimationController _controller;
  int _state = 0;
  double _width = double.maxFinite;

  //
  // Future<void> navigationPage() async {
  //   Session prefs = Session();
  //   Future<String> authName = prefs.getName();
  //   authName.then((data) {
  //     if (data != "") {
  //       print("data ${data.toString()}");
  //       Navigator.of(context).pushReplacementNamed(home.name);
  //     } else {
  //       print("data ${data.toString()}");
  //       Navigator.of(context).pushReplacementNamed(enterName.name);
  //     }
  //   }, onError: (e) {
  //     print("data ${e.toString()}");
  //     Navigator.of(context).pushReplacementNamed(enterName.name);
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          child: Center(
            child: ListView(
              children: <Widget>[
                Column(children: [
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Enter unique name",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    controller: textFormFieldcon,
                    validator: (val) {
                      if (val.length == 0) {
                        return "name cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.name,
                    style: new TextStyle(fontFamily: "Poppins", fontSize: 20),
                  ),
                ]),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green.shade200,
                            offset: Offset(1, -2),
                            blurRadius: 5),
                        BoxShadow(
                            color: Colors.green.shade200,
                            offset: Offset(-1, 2),
                            blurRadius: 5)
                      ]),
                  child: MaterialButton(
                    key: _globalKey,
                    minWidth: _width,
                    child: setUpButtonChild(),
                    onPressed: () {
                      setState(() {
                        if (textFormFieldcon.text.isEmpty ||
                            textFormFieldcon.text.length < 3) {
                          _displaySnackBar(
                              context, "Type at least 3 characters", null);
                        } else {
                          if (_state == 0) {
                            animateButton();
                          }
                          createRecord(textFormFieldcon.text.trim(), context);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createRecord(String uniquename, BuildContext context) async {
    final databaseReference = FirebaseFirestore.instance;
    await databaseReference
        .collection("dashboard")
        .doc(uniquename)
        .get()
        .then((docSnapshot) async {
      if (docSnapshot.exists) {
        setState(() {
          _state = 0;
        });
        _displaySnackBar(context, "already exists", uniquename);
      } else {
        final databaseReference = FirebaseFirestore.instance;
        await databaseReference
            .collection("dashboard")
            .doc(uniquename)
            .set({'total': 10, 'Bonus': 2}).whenComplete(
                () => {print("printkaro : completed")});
        setState(() {
          _state = 2;
        });
      }
    });
  }

  Widget setUpButtonChild() {
    if (_state == 0) {
      //check or not already in data
      return Center(
          child: Text(
        "CHECK",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ));
    } else if (_state == 1) {
      // progress.....
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else if (_state == 2) {
      //verified
        Session prefs = Session();
        prefs.setName(textFormFieldcon.text.trim().toString());
        final databaseReference = FirebaseFirestore.instance;

        Future<String> authNumber = prefs.getmoNumber();
        authNumber.then((number) async => {
              await databaseReference.collection("userrecord").doc(number).set({
                'name': textFormFieldcon.text.trim().toString()
              }).whenComplete(() => {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => new home()))
                  })
            });

        // Navigator.of(context).pushReplacementNamed(home.name);
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });
    _controller.forward();

    setState(() {
      _state = 1;
    });
  }

  _displaySnackBar(BuildContext context, String s, String uniquename) {
    final snackBar = SnackBar(
      duration: const Duration(milliseconds: 300),
      content: RichText(
        text: TextSpan(
            text: uniquename,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            children: <TextSpan>[
              TextSpan(
                  text: " " + s,
                  style: TextStyle(
                    color: Colors.white70,
                  ))
            ]),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
