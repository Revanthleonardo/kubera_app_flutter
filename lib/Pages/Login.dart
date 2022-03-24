import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/LoginResponse.dart';
import 'package:kubera_app/Pages/ForgotPassWord/ForgotPassword.dart';
import 'package:kubera_app/Pages/HomePage.dart';
import 'package:kubera_app/Pages/Register.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';
import 'package:kubera_app/Util/Utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  LoginResponse _loginResponse;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  bool isPasswordVisible = false;

  loginAPI(BuildContext context, String mobileNo, String passWord) async {
    AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().loginAPI(mobileNo, passWord);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);

          if (list[0]['result'] == 'success') {
            _loginResponse = loginResponseFromJson(vStatus);
            _saveUserData(
              _loginResponse.userLoginApi.userId,
              _loginResponse.userLoginApi.name,
              _loginResponse.userLoginApi.mobileNumber,
              _loginResponse.userLoginApi.email,
              _loginResponse.userLoginApi.password,
              _loginResponse.referralNumber,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return HomePage();
              }),
            );
          } else {
            showUserSnak('Please enter valid mobile no and password', false);
          }
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        //  Navigator.pop(context);
        showUserSnak("Internal Server Error", false);
      });
    }
  }

  _saveUserData(String userId, String userName, String mobileNo, String email,
      String passWord, String refNo) async {
    final bool result = await SharedPreference().setUserName(userName);
    final bool resul1t = await SharedPreference().setuserId(userId);
    print(resul1t.toString() + "setUserId");
    final bool resul1t1 = await SharedPreference().setMobileNo(mobileNo);
    final bool resul1t1t = await SharedPreference().setUserEmail(email);
    final bool resultUserName = await SharedPreference().setPassWord(passWord);
    final bool resultRollType = await SharedPreference().setRefferralNo(refNo);
  }

  bool validateDetails() {
    if (mobileController.text.isEmpty) {
      showUserSnak('Please enter mobile number', false);
      return false;
    } else if (mobileController.text.length <= 9) {
      showUserSnak('Please enter valid mobile number', false);
      return false;
    } else if (passWordController.text.isEmpty) {
      showUserSnak('Please enter password', false);
      return false;
    } else
      return true;
  }

  showUserSnak(String msg, bool flag) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: (flag) ? Colors.black54 : ColorResources.APP_THEME_COLOR,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                color: ColorResources.APP_THEME_COLOR,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Utils.book_icon_path,
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      "KUBERAA",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Text(
                  'Login to Continue',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 12),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                        labelText: "MOBILE NO",
                        prefixText: "(+91) ",
                        prefixStyle: TextStyle(fontSize: 14),
                        labelStyle: TextStyle(fontSize: 12),
                        hintText: "")),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                    controller: passWordController,
                    style: TextStyle(fontSize: 12),
                    obscureText: !isPasswordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        labelText: "PASSWORD",
                        labelStyle: TextStyle(fontSize: 12),
                        suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(isPasswordVisible == false
                                ? Icons.visibility_off
                                : Icons.visibility)),
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
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  onPressed: () {
                    if (validateDetails() == true) {
                      loginAPI(context, mobileController.text,
                          passWordController.text);
                    }
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) {
                    //     return HomePage();
                    //   }),
                    // );
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => RegisterPage(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 400),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(onTap: (){
                 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ForgotPage();
              }),
            );
              },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text('Fotgot Password ?'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
