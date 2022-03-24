import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:kubera_app/Pages/HomePage.dart';
import 'package:kubera_app/Pages/Login.dart';
import 'package:kubera_app/Pages/SplashSreen.dart';
import 'package:kubera_app/Util/SharedPref.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SplashUI(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Slide> slides = [];
  String userId = '';

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        backgroundImage: "assets/image/slide_one.png",
         backgroundOpacity: 0.0,
        maxLineTextDescription: 3,
      ),
    );
    slides.add(
      Slide(
        backgroundImage: "assets/image/slide_two.png",
        backgroundOpacity: 0.0,
        maxLineTextDescription: 3,
      ),
    );
    slides.add(
      Slide(
        backgroundImage: "assets/image/slide_four.png",
        backgroundOpacity: 0.0,
        maxLineTextDescription: 3,
      ),
    );
    loadInitial();
  }

  loadInitial() async {
    var _userId = await SharedPreference().getUserId();
    setState(() {
      userId = _userId;
      print(_userId);
    });
  }

  void onDonePress() {
    if (userId != null && userId.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage();
        }),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    }
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Color(0xffF3B4BA),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.black,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Color(0xffF3B4BA),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      // renderSkipBtn: this.renderSkipBtn(),
      // skipButtonStyle: myButtonStyle(),

      // Next button
      // renderNextBtn: this.renderNextBtn(),
      // nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: Color(0x33FFA8B0),
      colorActiveDot: Color(0xffFFA8B0),
      sizeDot: 13.0,

      // Show or hide status bar
      hideStatusBar: true,

      // Scrollbar
      verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
    );
  }
}
