import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifeshare/pages/tabs.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Donations.dart';


class WebViewContainer extends StatefulWidget {
  final url;

  WebViewContainer(this.url);

  @override
  createState() => _WebViewContainerState(this.url);
}

class _WebViewContainerState extends State<WebViewContainer> {
  var _url;
  final _key = UniqueKey();

  _WebViewContainerState(this._url);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
        appBar:AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            "Donate",
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
                          Donations()));
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: WebView(
                    key: _key,
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _url))
          ],
        ));
  }
}
