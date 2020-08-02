import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifeshare/pages/RequestFIilter.dart';
import 'package:lifeshare/pages/tabs.dart';
import 'package:lifeshare/utils/customWaveIndicator.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class Requests extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<Requests> {
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String _selectedg = '';
  bool _categorySelected = false;
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
    super.initState();
  }

  Future<Null> getDonors() async {
    await Firestore.instance
        .collection('Blood Request Details')
        .where(null)
        .orderBy('date')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          _name.add(docs.documents[i].data['Name']);
          mobile.add(docs.documents[i].data['phone']);
          bloodgroup.add(docs.documents[i].data['bloodGroup']);
          date.add(docs.documents[i].data['dueDate']);
          address.add(docs.documents[i].data['address']);
          quantity.add(docs.documents[i].data['quantity']);
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
          "Requests",
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
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Tabs()));
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
                          RequestsFilter(value)));
            },
            icon: Icon(Icons.list),
          )
        ],
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: mobile.length,
          itemBuilder: (BuildContext context, int index) {
            return buildList(context, index);
          }),
    );
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
