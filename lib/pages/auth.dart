import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lifeshare/pages/resetPassword.dart';
import 'package:lifeshare/pages/responsive_ui.dart';
import 'package:lifeshare/pages/tabs.dart';
import 'package:lifeshare/pages/textformfield.dart';
import 'package:lifeshare/utils/customDialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'custom_shape.dart';
import 'register.dart';


class AuthPage extends StatefulWidget {
  final FirebaseAuth appAuth;
  AuthPage(this.appAuth);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formkey = new GlobalKey<FormState>();
  String _email;
  String _password;
  bool verify;
  // ignore: non_constant_identifier_names
  bool validate_save() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validate_submit() async {
    if (validate_save()) {
      try {
        CustomDialogs.progressDialog(context: context, message: 'Signing In',);
       FirebaseUser user = (await widget.appAuth.
signInWithEmailAndPassword(email: _email, password: _password))
.user;
        Navigator.pop(context);
        print('Signed in: ${user.uid}');
        if (user.isEmailVerified) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Tabs()));
        }
        else{
          showDialog(
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Verify your email'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () async{
                        await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthPage(FirebaseAuth.instance)));
                      },
                    )
                  ],
                );
              },
              context: context
          );
        }
      } catch (e) {
        print('Errr : $e');
        showDialog(
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('User Sign-In Failed !'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      formkey.currentState.reset();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
            context: context);
      }
    }
  }

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();



  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
            welcomeTextRow(),
              signInTextRow(),
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: _width / 12.0,
                            right: _width / 12.0,
                            top: _height / 15.0),
                        child: new Form(
                          key: formkey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    hintText: 'Email ID',
                                    icon: Icon(
                                      FontAwesomeIcons.envelope,
                                      color: Colors.black,size: 20,
                                    ),
                                  ),
                                  validator: (value) {
                                    String pattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regExp = new RegExp(pattern);
                                    if (value.length == 0) {
                                      return "Email is Required";
                                    } else if (!regExp.hasMatch(value)) {
                                      return "Invalid Email";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onSaved: (value) => _email = value,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    icon: Icon(
                                      FontAwesomeIcons.userLock,
                                      color: Colors.black,size: 20,
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if(value.length==0){
                                      return "Password can't be empty";
                                    } else if (value.length < 10){
                                      return "Password must be longer than 10 characters";
                                    }
                                    return null;
                                  } ,
                                  onSaved: (value) => _password = value,
                                ),
                              ),
                              forgetPassTextRow(context),
                              SizedBox(height: _height /40),
                              RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                onPressed: validate_submit,
                                textColor: Colors.white,
                                padding: EdgeInsets.all(0.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: _large? _width/4 : (_medium? _width/3.75: _width/3.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    gradient: LinearGradient(
                                      colors: <Color>[Colors.black, Colors.black54],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text('SIGN IN',style: TextStyle(fontSize: _large? 14: (_medium? 12: 10))),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: _height / 25),
              signUpTextRow(context),

            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height:_large? _height/4 : (_medium? _height/3.75 : _height/3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black54],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/4.5 : (_medium? _height/4.25 : _height/4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black54],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top: _large? _height/30 : (_medium? _height/25 : _height/20)),
          child: Image.asset(
            'assets/login.png',
            height: _height/3.5,
            width: _width/3.5,
          ),
        ),
      ],
    );
  }
  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large? 60 : (_medium? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }
  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large? 20 : (_medium? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget forgetPassTextRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          reset(widget.appAuth)));
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget signUpTextRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.w400,fontSize: _large? 14: (_medium? 12: 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          RegisterPage(widget.appAuth)));
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.black, fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }
}
