import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifeshare/utils/customWaveIndicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MyRequests extends StatefulWidget {
  @override
  _MyRequestsPageState createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequests> {
  FirebaseUser currentUser;
  final primary = Colors.black;
  final secondary = Colors.black;
  List<String> _name=[];
  List<String> mobile = [];
  List<String> bloodgroup = [];
  List<String>  date=[];
  List<String>  quantity=[];
  List<String>  address=[];
  Widget _child;

  @override
  void initState() {
    _child = WaveIndicator();
    getDonors();
    _loadCurrentUser();
    super.initState();
  }
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
          .collection('Blood Request Details')
          .document()
          .setData(_user)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged In');
    }
  }

  Future<void> _loadCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }
  Future<Null> getDonors() async {
    await Firestore.instance
        .collection('Blood Request Details')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if (docs.documents[i].data['uid']==currentUser.uid) {
            _name.add(docs.documents[i].data['Name']);
            mobile.add(docs.documents[i].data['phone']);
            bloodgroup.add(docs.documents[i].data['bloodGroup']);
            date.add(docs.documents[i].data['dueDate']);
            address.add(docs.documents[i].data['address']);
            quantity.add(docs.documents[i].data['quantity']);
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
          "My Requests",
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: mobile.length,
            itemBuilder: (BuildContext context, int index) {
              return buildList(context, index);
            }),
      ),
    );
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Deleted'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyRequests()));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
            ],
          );
        });
  }
  Future<Null> Delete(int index) async {
    await Firestore.instance
        .collection('Blood Request Details')
        .getDocuments()
        .then((docs) async{
      await Firestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(docs.documents[index].reference).then((result) {
          dialogTrigger(context);
        }).catchError((e) {
          print(e);
        });;
      });
    });
    setState(() {
      _child = myWidget();
    });
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.black12,
      ),
      width: double.infinity,
      height: 130,
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
                      _name[index],
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
                          Icons.location_on,
                          color: secondary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(address[index],
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
                          Icons.calendar_today,
                          color: secondary,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Due Date: ",style: TextStyle(
                            color: Colors.red, fontSize: 13, letterSpacing: .3)),
                        Text(date[index],
                            style: TextStyle(
                                color: Colors.red, fontSize: 13, letterSpacing: .3)),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.prescriptionBottle,
                          color: secondary,
                          size: 15,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Quantity: ",style: TextStyle(
                            color: Colors.red, fontSize: 15, letterSpacing: .3,fontWeight: FontWeight.bold)),
                        Text(quantity[index]+" L",
                            style: TextStyle(
                                color: Colors.red, fontSize: 15, letterSpacing: .3,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        leading: CircleAvatar(
          radius:35 ,
          child: Text(
            bloodgroup[index],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        trailing:  IconButton(
          iconSize: 33,
          icon: Icon(Icons.delete_forever),
          onPressed: () {Delete(index);
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
