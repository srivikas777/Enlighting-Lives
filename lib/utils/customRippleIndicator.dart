import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RippleIndicator extends StatelessWidget {
  String message;
  RippleIndicator(this.message);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Center(
                    child: SpinKitRipple(
                  color: Colors.black,
                )),
              ),
              SizedBox(width: 10.0),
              Text(
                message, style: TextStyle(color:Colors.black),
              ),
            ],
          )),
    );
  }
}
