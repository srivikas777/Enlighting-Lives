import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lifeshare/pages/eventdetails.dart';
import 'package:lifeshare/pages/tabs.dart';
import 'package:lifeshare/utils/customWaveIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:share/share.dart';
//pages import

//utils import
import 'package:lifeshare/utils/customDialogs.dart';

import 'network_image.dart';

class Gallery extends StatefulWidget {
  @override
  _CampaignsPageState createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<Gallery> {
  final List<StaggeredTile> _staggeredTiles = [];

  FirebaseUser currentUser;
  final formkey = new GlobalKey<FormState>();
  String _name;
  int _height;
  int _width;
  List<String> names = [];
  List<String> _url = [];
  List<String> date = [];
  List<String> content = [];
  Widget _child;
  @override
  void initState() {
    _child = WaveIndicator();
    getDonors();
    super.initState();
    _loadCurrentUser();
  }

  Future<Null> getDonors() async {
    await Firestore.instance
        .collection('Gallery')
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          names.add(docs.documents[i].data['name']);
          _url.add(docs.documents[i].data['image']);
          _staggeredTiles.add(StaggeredTile.count((docs.documents[i].data['Width']), (docs.documents[i].data['Height'])));
          //date.add(docs.documents[i].data['date']);
          //content.add(docs.documents[i].data['content']);
        }
      }
    });
    setState(() {
      _child = myWidget();
    });
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
          .collection('Gallery')
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

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Image Uploaded'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  formkey.currentState.reset();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Gallery()));
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

  Future<bool> deleteTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Image Deleted'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Gallery()));
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
        .collection('Gallery')
        .getDocuments()
        .then((docs) async{
      await Firestore.instance.runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(docs.documents[index].reference).then((result) {
          deleteTrigger(context);
        }).catchError((e) {
          print(e);
        });;
      });
    });
    setState(() {
      _child = myWidget();
    });
  }

  File _image;
  String _path;

  Future getImage(bool isCamera) async {
    File image;
    String path;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
      path = image.path;
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
      path = image.path;
    }
    setState(() {
      _image = image;
      _path = path;
    });
  }

  Future<String> uploadImage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Eventposters/${user.uid}/$_name.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Widget myWidget(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF3F3F3),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Gallery",
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
                        Tabs()));
          },
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Text("Add New"),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Event Details"),
                  content: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Name',
                                icon: Icon(
                                  FontAwesomeIcons.user,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) => value.isEmpty
                                  ? "This field can't be empty"
                                  : null,
                              onSaved: (value) => _name = value,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: '0 < Height <= 3',
                                icon: Icon(
                                  FontAwesomeIcons.pen,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value){
                                if (value.length == 0) {
                                  return "Height is Required";
                                } else if (value.length != 1) {
                                  return "Height must single digit";
                                } else if (value != '1' && value != '2' && value != '3') {
                                  return "Height Number must be 1 or 2 or 3";
                                }
                                return null;
                              },
                              onSaved: (value) => _height = int.parse(value),
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: '0 < Width <= 3',
                                icon: Icon(
                                  FontAwesomeIcons.pen,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value){
                                if (value.length == 0) {
                                  return "Width is Required";
                                } else if (value.length != 1) {
                                  return "Width must single digit";
                                } else if (value != '1' && value != '2' && value != '3') {
                                  return "Width Number must be 1 or 2 or 3";
                                }
                                return null;
                              },
                              onSaved: (value) => _width = int.parse(value),
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    getImage(true);
                                  }),
                              IconButton(
                                  icon: Icon(Icons.filter),
                                  onPressed: () {
                                    getImage(false);
                                  }),
                            ],
                          ),
                          _image == null
                              ? Container()
                              : Image.file(
                            _image,
                            height: 150.0,
                            width: 300.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      color: Colors.black,
                      onPressed: ()async {
                        if (!formkey.currentState.validate()) return;
                        formkey.currentState.save();
                        CustomDialogs.progressDialog(
                            context: context, message: 'Uploading');
                        var url = await uploadImage();
                        Navigator.of(context).pop();
                        final Map<String, dynamic> gallery = {
                          'uid': currentUser.uid,
                          'Height': _height,
                          'image': url,
                          'name': _name,
                          'Width':_width,
                        };
                        addData(gallery).then((result) {
                          dialogTrigger(context);
                        }).catchError((e) {
                          print(e);
                        });
                      },
                      child: Text(
                        'POST',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: StaggeredGridView.countBuilder(
        padding: const EdgeInsets.all(8.0),
        crossAxisCount: 3,
        itemCount: _url.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _showImageDialog(context, _url[index], index),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                  CachedNetworkImageProvider(_url[index]),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
        staggeredTileBuilder: (index) => _staggeredTiles[index],
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(_url[index]),
                              fit: BoxFit.cover,
                            )),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  Details(names[index], _url[index], date[index], content[index])));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        names[index],style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            date[index],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showImageDialog(BuildContext context, String image, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: PNetworkImage(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(image);
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Delete(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
