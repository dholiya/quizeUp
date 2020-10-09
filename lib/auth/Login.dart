import 'dart:async';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizup/Util/testData.dart';
import 'file:///D:/flutter/firebase/quizup/lib/auth/otpPage.dart';
import 'SocialLogin.dart';

class Login extends StatelessWidget {
  static String name = "/login";

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Welcome to Flutter', home: MyLogin());
  }
}

class MyLogin extends StatefulWidget {
  MyLogin({this.app});

  FirebaseApp app;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<MyLogin> {
  final referenceData = FirebaseDatabase.instance;
  String countrycode = "";
  bool VISIVILITY_NUMBER = true;
  bool VISIVILITY_OTP = false;

  @override
  initState() {
    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  BuildContext scaffoldContext;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ref = referenceData.reference();
    scaffoldContext = context;
    return MaterialApp(
      title: 'QuizUp',
      home: Scaffold(
        backgroundColor: Colors.blue.shade50,
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              child: _listView(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _listView(BuildContext acontext) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Visibility(
            visible: VISIVILITY_NUMBER,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              //Center Row contents vertically,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Card(
                    child: CountryCodePicker(
                      onChanged: (code) => countrycode = code.dialCode,
                      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                      favorite: ['+91', 'IN'],
                      onInit: (code) => print(
                          "on init ${code.name} ${code.dialCode} ${code.name}"),
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Card(
                    color: Colors.white,
                    child: TextFormField(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      controller: mobileController,
                      decoration: IFFinputfield("Enter number"),
                      keyboardType: TextInputType.number,
                      validator: (mobileController) {
                        if (mobileController.isEmpty) {
                          return ' \u26A0 Please enter number';
                        }
                        return null;
                      },
                      onChanged: (txt) {},
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
              visible: VISIVILITY_OTP,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                          onPressed: () async {
                            setState(() {
                              VISIVILITY_OTP = false;
                            });

                            if (!_formKey.currentState.validate()) {
                              print("data : invalid");
                              // _displaySnackBar(context, "Invalid Mobile Number");
                            } else {
                              _displaySnackBar(
                                  context, "OTP Resend Successfully");
                              print("data : valid${mobileController.text}");
                              print(
                                  "fdvm number: ${countrycode + "" + mobileController.text}");
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    countrycode + " " + mobileController.text,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {
                                  print(
                                      "fdvm verificationCompleted: ${credential}");
                                  setState(() {
                                    Navigator.push(
                                      scaffoldContext,
                                      MaterialPageRoute(
                                          builder: (scaffoldContext) => signIn(
                                              credential.smsCode,
                                              countrycode +
                                                  " " +
                                                  mobileController.text,
                                              credential)),
                                    );
                                    VISIVILITY_OTP = false;
                                  });
                                },
                                verificationFailed: (FirebaseAuthException e) {
                                  print("fdvm verificationFailed: ${e}");
                                  setState(() {
                                    VISIVILITY_OTP = true;
                                  });
                                },
                                timeout: Duration(seconds: 10),
                                codeSent:
                                    (String verificationId, int resendToken) {
                                  print(
                                      "fdvm verificationId: ${resendToken} = ${verificationId}");
                                  setState(() {
                                    VISIVILITY_OTP = false;
                                  });
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {
                                  setState(() {
                                    VISIVILITY_OTP = true;
                                  });
                                  print(
                                      "fdvm codeAutoRetrievalTimeout:${verificationId}");
                                },
                              );
                            }
                          },
                          child: Text(
                            "Resend OTP",
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          ))))),
          Container(
              height: 58,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
              child: RaisedButton(
                child: Text(
                  "Send OTP",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                color: Colors.white,
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    print("data : invalid");
                    // _displaySnackBar(context, "Invalid Mobile Number");
                  } else {
                    _displaySnackBar(context, "Send Successfully");
                    print("data : valid${mobileController.text}");
                    print(
                        "fdvm number: ${countrycode + "" + mobileController.text}");
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: countrycode + " " + mobileController.text,
                      verificationCompleted: (PhoneAuthCredential credential) {
                        print(
                            "fdvm verificationCompleted: ${credential.smsCode}");

                        setState(() {
                          VISIVILITY_OTP = false;
                          Navigator.push(
                            scaffoldContext,
                            MaterialPageRoute(
                                builder: (scaffoldContext) => signIn(
                                    credential.smsCode,
                                    countrycode + " " + mobileController.text,
                                    credential)),
                          );
                        });
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        print("fdvm verificationFailed: ${e}");
                        setState(() {
                          VISIVILITY_OTP = true;
                        });
                      },
                      timeout: Duration(seconds: 10),
                      codeSent: (String verificationId, int resendToken) {
                        print(
                            "fdvm verificationId: ${resendToken} = ${verificationId}");
                        setState(() {
                          VISIVILITY_OTP = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        setState(() {
                          VISIVILITY_OTP = true;
                        });
                        print(
                            "fdvm codeAutoRetrievalTimeout:${verificationId}");
                      },
                    );
                  }
                },
              )),
          //

          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 58,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _signInButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    // setState(() {
                    PhoneAuthCredential abc;
                    Navigator.push(
                      scaffoldContext,
                      MaterialPageRoute(
                          builder: (scaffoldContext) => signIn(
                              testData.test_opt, testData.test_mobile, abc)),
                    );
                    // });
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        setState(() {
          signInWithGoogle().then((result) {
            if (result != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ),
              );
            }
          });
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Container(),
            Container(
              child: Row(
                children: [
                  Image(
                      image: AssetImage("assets/images/google_log.png"),
                      height: 35.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration IFFinputfield(String hint) {
    return InputDecoration(
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.black54),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorStyle: TextStyle(color: Colors.red),
      contentPadding: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
    );
  }

  _displaySnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(content: Text(s));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
