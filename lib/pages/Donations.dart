import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:lifeshare/pages/tabs.dart';
import 'package:lifeshare/pages/web_view_container.dart';
import 'network_image.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'swiper_pagination.dart';

class Donations extends StatefulWidget {
  static final String path = "lib/src/pages/onboarding/intro4.dart";
  @override
  _IntroFourPageState createState() => _IntroFourPageState();
}

class _IntroFourPageState extends State<Donations> {
  final SwiperController  _swiperController = SwiperController();
  final int _pageCount = 3;
  int _currentIndex = 0;
  final List<String> titles = [
    "The best way to find yourself is to lose yourself in the service of others... ",
    "The best feeling of HAPPINESS is when you're happy because you've made somebody else happy... ",
    "No one has ever become poor by giving..."
  ];

  final List<String> images = [
    'https://images.unsplash.com/photo-1578357078586-491adf1aa5ba?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80',
    'https://images.unsplash.com/photo-1550098215-ea7d7535e78e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=375&q=80',
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
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
                        Tabs()));
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: PNetworkImage('https://images.unsplash.com/photo-1468421870903-4df1664ac249?ixlib=rb-1.2.1&auto=format&fit=crop&w=1189&q=80', fit: BoxFit.contain,),
          ),
          Column(
            children: <Widget>[
              Expanded(child: Swiper(
                index: _currentIndex,
                controller: _swiperController,
                itemCount: _pageCount,
                onIndexChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                loop: false,
                itemBuilder: (context, index){
                  return _buildPage(title: titles[index], icon: images[index]);
                },
                pagination: SwiperPagination(
                    builder: CustomPaginationBuilder(
                        activeSize: Size(10.0, 20.0),
                        size: Size(10.0, 15.0),
                        color: Colors.grey.shade600
                    )
                ),
              )),
              SizedBox(height: 10.0),
              _buildButtons(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(){
    return Container(
      margin: const EdgeInsets.only(right: 16.0,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            textColor: Colors.grey.shade700,
            child: Text("Donate"),
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WebViewContainer('https://pmny.in/WIxiIclw2miM')));
            },
          ),
          IconButton(
            icon: Icon(_currentIndex < _pageCount - 1 ? FontAwesomeIcons.arrowCircleRight : FontAwesomeIcons.checkCircle, size: 40,),
            onPressed: () async {
              if(_currentIndex < _pageCount - 1)
                _swiperController.next();
              else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WebViewContainer('https://pmny.in/WIxiIclw2miM')));
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPage({String title, String icon}) {
    final TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20.0
    );
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(50.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          image: DecorationImage(
              image: CachedNetworkImageProvider(icon),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black38, BlendMode.multiply)
          ),
          boxShadow: [
            BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(5.0,5.0),
                color: Colors.black26
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(title, textAlign: TextAlign.center, style: titleStyle.copyWith(
              color: Colors.white
          ),),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}