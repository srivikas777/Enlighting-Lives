import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifeshare/pages/Donations.dart';
import 'package:lifeshare/pages/campaigns.dart';
import 'package:lifeshare/pages/donors.dart';
import 'package:lifeshare/pages/requestBlood.dart';
import 'package:lifeshare/pages/web_view_container.dart';

import 'home.dart';


class Tabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<Tabs> {
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: TabBarView(
            children: <Widget>[
              HomePage(),
              DonorsPage(),
              RequestBlood(),
              CampaignsPage(),
              Donations(),
            ],
          ),
          bottomNavigationBar: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home,color: Colors.white, size: 26.0),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.handshake,color:Colors.white, size: 26.0),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.heartbeat,color:Colors.white, size: 26.0),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.ribbon,color:Colors.white, size: 26.0),
              ),
              Tab(
                icon: Icon(Icons.redeem,color: Colors.white, size: 26.0),
              ),
            ],
            labelPadding: EdgeInsets.all(5.0),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black12,
            indicatorWeight: 0.01,
          ),
        ),
      ),
    );
  }
}
