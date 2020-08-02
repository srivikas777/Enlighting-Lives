import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifeshare/pages/textformfield.dart';
//
import 'package:lifeshare/utils/customDialogs.dart';
import 'auth.dart';
import 'custom_shape.dart';
import 'customappbar.dart';
import 'responsive_ui.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAuth appAuth;
  RegisterPage(this.appAuth);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;
  DateTime selectedDate = DateTime.now();
  List<String> _gender = ['Male','Female'];
  String _bmi = 'Dont Know' ;
  String _fname;
  String _adress;
  String _hissues = 'Dont Know';
  bool _volunteer=false;
  DateTime today = DateTime.now();
  int _mobile;
  var formattedDate;
  int flag = 0;
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String _selected = '';
  String _selectedg = '';
  bool _categorySelected = false;
  bool _categorySelectedg = false;
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(_user) async {
    if (isLoggedIn()) {
      Firestore.instance
          .collection('User Details')
          .document(_user['uid'])
          .setData(_user)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged In');
    }
  }

  bool validate_save() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validate_submit(BuildContext context) async {
    if (validate_save()) {
      try {
        CustomDialogs.progressDialog(
            context: context, message: 'Registration under process');
        FirebaseUser user = (await widget.appAuth
                .createUserWithEmailAndPassword(
                    email: _email, password: _password))
            .user;
        await user.sendEmailVerification();
        Navigator.pop(context);
        print('Registered User: ${user.uid}');
        final Map<String, dynamic> UserDetails = {
          'uid': user.uid,
          'name': _name,
          'mobile':_mobile,
          'email': _email,
          'bloodgroup': _selected,
          'Date of Birth':formattedDate,
          'BMI':_bmi,
          'Volunteer':_volunteer,
          'Health Issues':_hissues,
          'Gender':_selectedg,
          'Father Name':_fname,
          'Address':_adress,
        };
        addData(UserDetails).then((result) {
          print("User Added");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AuthPage(widget.appAuth)));
        }).catchError((e) {
          print(e);
        });
      } catch (e) {
        print('Errr : $e');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Registration Failed'),
                content: Text('Error : $e'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF000000),
            accentColor: const Color(0xFF000000),
            colorScheme: ColorScheme.light(primary: const Color(0xFF000000)),
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },

    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        flag = 1;
      });
    var date = DateTime.parse(selectedDate.toString());
    formattedDate = "${date.day}-${date.month}-${date.year}";

  }


  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                clipShape(),
                welcomeTextRow(),
                signInTextRow1(),
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
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      icon: Icon(
                                        Icons.account_circle,
                                        color: Colors.black,size: 20,
                                      ),
                                    ),
                                    validator: (value){
                                      String pattern = r'(^[a-zA-Z ]*$)';
                                      RegExp regExp = new RegExp(pattern);
                                      if (value.length == 0) {
                                        return "Name is Required";
                                      } else if (!regExp.hasMatch(value)) {
                                        return "Name must be a-z and A-Z";
                                      }
                                      return null;
                                    },
                                    maxLength: 26,
                                    onSaved: (value) => _name = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Father Name',
                                      icon: Icon(
                                        Icons.people,
                                        color: Colors.black,size: 20,
                                      ),
                                    ),
                                    validator: (value){
                                      String pattern = r'(^[a-zA-Z ]*$)';
                                      RegExp regExp = new RegExp(pattern);
                                      if (value.length == 0) {
                                        return "Father Name is Required";
                                      } else if (!regExp.hasMatch(value)) {
                                        return "Father Name must be a-z and A-Z";
                                      }
                                      return null;
                                    },
                                    maxLength: 26,
                                    onSaved: (value) => _fname = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Email ID',
                                      icon: Icon(
                                        Icons.email,
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
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      icon: Icon(
                                        Icons.lock,
                                        color: Colors.black,size: 20,
                                      ),
                                    ),
                                    obscureText: true,
                                    validator: (value){
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
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Mobile Number',
                                      icon: Icon(
                                        Icons.phone,
                                        color: Colors.black,size: 20,
                                      ),
                                    ),
                                    validator: (value) {
                                      String pattern = r'(^[0-9]*$)';
                                      RegExp regExp = new RegExp(pattern);
                                      if (value.length == 0) {
                                        return "Mobile is Required";
                                      } else if (value.length != 10) {
                                        return "Mobile number must 10 digits";
                                      } else if (!regExp.hasMatch(value)) {
                                        return "Mobile Number must be digits";
                                      }
                                      return null;
                                    },
                                    maxLength: 10,
                                    onSaved: (value) => _mobile = num.tryParse(value),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Address',
                                      icon: Icon(
                                        Icons.location_on,
                                        color: Colors.black,size: 20,
                                      ),
                                    ),
                                    validator: (value){
                                      if (value.length == 0) {
                                        return "Adress is Required";
                                      }
                                      return null;
                                    },
                                    maxLength: 120,
                                    onSaved: (value) => _adress = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'BMI',
                                      icon: Icon(
                                        Icons.accessibility_new,
                                        color: Colors.black,size: 20,
                                      ),
                                    ),
                                    onSaved: (value) => _bmi =value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Health Issues',
                                      icon: Icon(
                                        Icons.airline_seat_flat_angled,
                                        color: Colors.black,size: 20,
                                      ),
                                    ),
                                    onSaved: (value) => _hissues = value,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () => _selectDate(context),
                                        icon: Icon(FontAwesomeIcons.calendar),
                                        color: Colors.black,
                                      ),
                                      flag == 0
                                          ? Text(
                                        "<< Date of Birth",
                                        style: TextStyle(
                                            color: Colors.black54, fontSize: 15.0),
                                      )
                                          : Text(formattedDate),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: DropdownButton(
                                          hint: Text(
                                            'Gender',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          iconSize: 20.0,
                                          items: _gender.map((val) {
                                            return new DropdownMenuItem<String>(
                                              value: val,
                                              child: new Text(val),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedg = newValue;
                                              this._categorySelectedg = true;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        _selectedg,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: DropdownButton(
                                          hint: Text(
                                            'Please choose a Blood Group',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          iconSize: 20.0,
                                          items: _bloodGroup.map((val) {
                                            return new DropdownMenuItem<String>(
                                              value: val,
                                              child: new Text(val),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selected = newValue;
                                              this._categorySelected = true;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        _selected,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                acceptTermsTextRow(),
                                RaisedButton(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                  onPressed: () => validate_submit(context),
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(0.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width:_large? _width/4 : (_medium? _width/3.75: _width/3.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      gradient: LinearGradient(
                                        colors: <Color>[Colors.black, Colors.black54],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('SIGN UP', style: TextStyle(fontSize: _large? 14: (_medium? 12: 10)),),
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
                signInTextRow(),
                SizedBox(height: _height / 20.0),
              ],
            ),
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
            "Enlightening",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large? 60 : (_medium? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }
  Widget signInTextRow1() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "the Lives",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large? 20 : (_medium? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.black,
              value: _volunteer,
              onChanged: (bool newValue) {
                setState(() {
                  _volunteer = newValue;
                });
              }),
          Text(
            "In case of emergency,\nwill you volunteer to donate blood ?",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: _large? 12: (_medium? 11: 10)),
          ),
        ],
      ),
    );
  }
  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(AuthPage);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.black, fontSize: _large? 19: (_medium? 17: 15)),
            ),
          )
        ],
      ),
    );
  }
}
