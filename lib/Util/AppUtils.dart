import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class AppUtils {
  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return WillPopScope(
            onWillPop: () async => false,
            child: Material(
              type: MaterialType.transparency,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.height * 0.05,
                          child: LiquidCircularProgressIndicator(
                            value: 0.5, // Defaults to 0.5.
                            valueColor: AlwaysStoppedAnimation(Colors
                                .black), // Defaults to the current Theme's accentColor.
                            backgroundColor: Colors
                                .white, // Defaults to the current Theme's backgroundColor.
                            borderColor: Colors.white,
                            borderWidth: 5.0,
                            direction: Axis
                                .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                            center: Text(""),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Container(
                          child: Text(
                            title,
                            style: TextStyle(
                                fontFamily: "OpenSans-CondLight",
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
