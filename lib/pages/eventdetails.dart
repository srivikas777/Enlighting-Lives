import 'package:flutter/material.dart';

import 'network_image.dart';


class Details extends StatefulWidget {
  String names, _url, date, content ;
  Details(this.names, this._url,this.date,this.content);
  @override
  _DetailsState createState() => _DetailsState();
}


class _DetailsState extends State<Details>{
  @override
  Widget build(BuildContext context){
    String image = widget._url;
    return Scaffold(
      backgroundColor: Color(0xffF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Enlightening Lives",style: TextStyle(color: Colors.white,fontSize: 30),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                  height: 300,
                  width: double.infinity,
                  child: PNetworkImage(image,fit: BoxFit.cover,)),
              Container(
                margin: EdgeInsets.fromLTRB(16.0, 250.0,16.0,16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.names, style: Theme.of(context).textTheme.title,),
                    SizedBox(height: 10.0),
                    Text(widget.date),
                    SizedBox(height: 10.0),
                    Divider(),
                    SizedBox(height: 10.0,),
                    Text(widget.content, textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}