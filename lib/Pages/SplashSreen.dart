import 'package:flutter/material.dart';
import 'package:kubera_app/Pages/HomePage.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';
import 'package:kubera_app/main.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashUI extends StatefulWidget {
  @override
  State<SplashUI> createState() => _SplashUItate();
}

class _SplashUItate extends State<SplashUI> {
  @override
  void initState() {
    super.initState();
    loadInitial();
  }

  String userId = '';
  loadInitial() async {
    var _userId = await SharedPreference().getUserId();
    setState(() {
      userId = _userId;
      print(_userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
      navigateAfterSeconds: userId != null && userId.isNotEmpty
          ? new HomePage()
          : new MyHomePage(),
      backgroundColor: ColorResources.APP_THEME_COLOR,
      title: new Text(
        'KUBERAA',
        textScaleFactor: 2,
        style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16),
      ),
      image: new Image.asset('assets/icons/icon.png'),
      // loadingText: Text("Loading"),
      photoSize: 100.0,
      useLoader: false,
      //loaderColor: Colors.blue,
    );
  }
}
