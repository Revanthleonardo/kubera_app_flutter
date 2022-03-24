import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  String userName = '';
  String mobileNo = '';
  String userID = '';

  _loadInitial() async {
    var _userName = await SharedPreference().getUserName();
    var _mobileNo = await SharedPreference().getMobileNo();
    var _userID = await SharedPreference().getUserId();
    setState(() {
      userName = _userName;
      mobileNo = _mobileNo;
      userID = _userID;
    });
  }

  showUserSnak(String msg, bool flag) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: (flag) ? Colors.black54 : Colors.red,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorResources.APP_THEME_COLOR,
        centerTitle: true,
        title: Text(
          'Wallet'.toUpperCase(),
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
        actions: [],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 12),
        color: Colors.white,
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .2,
                color: ColorResources.APP_THEME_COLOR,
                child: Center(
                    child: Text(
                  'Change your password'.toUpperCase(),
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14),
                ))),
            Expanded(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                        controller: idController,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(fontSize: 12),
                            hintText: "")),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: EdgeInsets.only(top: 32),
                    height: 45,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: ColorResources.LIGHT_BLUE,
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 0.8),
                      ),
                      onPressed: () {
                        if (idController.text.isEmpty) {
                          showUserSnak('Please enter your new password', false);
                        } else {
                          this.updatePasswordAPI(
                              context, userID, idController.text);
                        }
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  updatePasswordAPI(
      BuildContext context, String userID, String passWord) async {
    AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().updatePassword(userID, passWord);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);

          if (list[0]['result'] == 'success') {
            showUserSnak('Your password is updated successfully', false);
          } else {
            // showUserSnak('Your ReferralCode is already updated', false);
          }
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        Navigator.pop(context);
        //  showUserSnak("Internal Server Error", false);
      });
    }
  }
}
