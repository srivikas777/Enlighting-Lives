import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifeshare/pages/Donations.dart';
import 'package:lifeshare/pages/Requests.dart';
import 'package:lifeshare/pages/campaigns.dart';
import 'package:lifeshare/pages/gallery.dart';
import 'package:lifeshare/pages/profile.dart';
import 'package:lifeshare/pages/requestBlood.dart';
import 'package:lifeshare/pages/web_view_container.dart';
import 'oval-right-clipper.dart';
//pages import
import './auth.dart';
import './mapView.dart';
import 'MyRequest.dart';
import 'donors.dart';
//utils import
import 'package:lifeshare/utils/customWaveIndicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color primary = Colors.white;
  final Color active = Colors.black;

  FirebaseUser currentUser;
  String _name, _bloodgrp, _email;
  Widget _child;

  Future<Null> _fetchUserInfo() async {
    Map<String, dynamic> _userInfo;
    FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot _snapshot = await Firestore.instance
        .collection("User Details")
        .document(_currentUser.uid)
        .get();

    _userInfo = _snapshot.data;

    this.setState(() {
      _name = _userInfo['name'];
      _email = _userInfo['email'];
      _bloodgrp = _userInfo['bloodgroup'];
      _child = _myWidget();
    });
  }

  Future<void> _loadCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  @override
  void initState() {
    _child = WaveIndicator();
    _loadCurrentUser();
    _fetchUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return _child;
  }
  Widget _myWidget() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Home",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
      ),
      drawer: _buildDrawer(),
      body: ClipRRect(
        child: Container(
          height: 800.0,
          width: double.infinity,
          color: Colors.white,
          child: MapView(),
        ),
      ),
    );
  }
  _buildDrawer() {
    //final String image = images[0];
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: active,
                      ),
                      onPressed:  () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthPage(FirebaseAuth.instance)));
                      },
                    ),
                  ),
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.black54])),
                    child: GestureDetector(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor:Colors.black,
                        child: Text(
                          currentUser == null ? "" : _bloodgrp,
                          style: TextStyle(
                            fontSize: 30.0,
                            color: primary,
                          ),
                        ),
                      ),
                      onTap: (){
                      },
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    currentUser == null ? "" : _name,
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                  Text(currentUser == null ? "" : _email),
                  SizedBox(height: 30.0),
                  ListTile(
                    title: Text("Home",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      FontAwesomeIcons.home,
                      color: active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Request Blood",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      FontAwesomeIcons.heartbeat,
                      color: active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RequestBlood()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Blood Donors",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      FontAwesomeIcons.handshake,
                      color:active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DonorsPage()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Blood Requests",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      FontAwesomeIcons.burn,
                      color: active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Requests()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("MY REQUESTS",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      FontAwesomeIcons.user,
                      color: active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyRequests()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Campaigns",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      FontAwesomeIcons.ribbon,
                      color:active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CampaignsPage()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Gallery",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      Icons.photo,
                      color:active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Gallery()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Donate",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      Icons.redeem,
                      color:active,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Donations()));
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    title: Text("Logout",style: TextStyle(color: active, fontSize: 16.0)),
                    leading: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: active,
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthPage(FirebaseAuth.instance)));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: active,
    );
  }
}
