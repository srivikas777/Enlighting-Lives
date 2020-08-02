import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifeshare/pages/donors.dart';
import 'package:lifeshare/pages/tabs.dart';
import 'package:lifeshare/utils/customWaveIndicator.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class DonorsFilter extends StatefulWidget {
  String grp;
  DonorsFilter(this.grp);
  @override
  _DonorsFilterState createState() => _DonorsFilterState();
}

class _DonorsFilterState extends State<DonorsFilter> {
  final primary = Colors.black;
  final secondary = Colors.black;
  List<String> donors = [];
  List<String> bloodgroup = [];
  List<String> email = [];
  List<int> mobile = [];
  Widget _child;

  @override
  void initState() {
    _child = WaveIndicator();
    getDonors();
    super.initState();
  }

  Future<Null> getDonors() async {
    await Firestore.instance
        .collection('User Details')
        .where('bloodgroup',isEqualTo: widget.grp)
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if((docs.documents[i].data['Volunteer']==true)) {
            donors.add(docs.documents[i].data['name']);
            bloodgroup.add(docs.documents[i].data['bloodgroup']);
            email.add(docs.documents[i].data['email']);
            mobile.add(docs.documents[i].data['mobile']);
          }
        }
      }
    });
    setState(() {
      _child = myWidget();
    });
  }

  Widget myWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Donors",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DonorsPage()));
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (context) =>[
              PopupMenuItem(
                value: "A+",
                child: Text("A+"),
              ),
              PopupMenuItem(
                value: "A-",
                child: Text("A-"),
              ),
              PopupMenuItem(
                value: "B+",
                child: Text("B+"),
              ),
              PopupMenuItem(
                value: "B-",
                child: Text("B-"),
              ),
              PopupMenuItem(
                value: "O+",
                child: Text("O+"),
              ),
              PopupMenuItem(
                value: "O-",
                child: Text("O-"),
              ),
              PopupMenuItem(
                value: "AB+",
                child: Text("AB+"),
              ),
              PopupMenuItem(
                value: "AB-",
                child: Text("AB-"),
              ),

            ],
            onSelected: (value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Tabs()));
            },
            icon: Icon(Icons.list),
          )
        ],
      ),
      body:
      SafeArea(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: donors.length,
            itemBuilder: (BuildContext context, int index) {
              return buildList(context, index);
            }),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black12,
      ),
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ListTile(
        title:SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      donors[index],
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.contact_mail,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(email[index],
                            style: TextStyle(
                                color: primary, fontSize: 13, letterSpacing: .3)),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),

                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.contact_phone,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(mobile[index].toString(),
                            style: TextStyle(
                                color: primary, fontSize: 13, letterSpacing: .3)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        leading: CircleAvatar(
          radius:30 ,
          child: Text(
            bloodgroup[index],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        trailing:  IconButton(
          icon: Icon(Icons.phone),
          onPressed: () {
            UrlLauncher.launch("tel:${mobile[index]}");
          },
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
