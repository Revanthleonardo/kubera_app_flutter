import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/LoginResponse.dart';
import 'package:kubera_app/Pages/HomePage.dart';
import 'package:kubera_app/Pages/Register.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:otp_text_field/style.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:kubera_app/Util/Utils.dart';

class ForgotPage extends StatefulWidget {
  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String enteredOtpStr = '', otpStr = '';
  bool isPasswordVisible = false;
  TextEditingController passWordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isOtpLayout = false;
  bool isPassWordLay = false;

  @override
  void initState() {
    super.initState();
  }

  getOTPApi(BuildContext context, String mobileNo) async {
    AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getOTP_API(mobileNo);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);

          if (list[0]['result'].toString()== 'success') {
            isOtpLayout = true;
            otpStr = list[0]['otp'].toString();
          } else {
            showUserSnak('Please enter valid mobile no', false);
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

  forgotPassWord(BuildContext context, String mobileNo, String otp,
      String newPassCode) async {
    AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus =
        await ApiInterface().passWordChangeAPI(mobileNo, otp, newPassCode);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);

          if (list[0]['result'] == 'success') {
            Navigator.pop(context);
          } else {
            showUserSnak('Please enter valid mobile no', false);
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
          color: Colors.white,
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
                  'Forgot Password',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Visibility(
                visible: isPassWordLay == false && isOtpLayout == true
                    ? true
                    : false,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(top: 32),
                  child: OTPTextField(
                    length: 4,
                    fieldWidth: 80,
                    style: TextStyle(fontSize: 16),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    onCompleted: (pin) {
                      setState(() {
                        enteredOtpStr = pin;
                      });
                    },
                  ),
                ),
              ),
              Visibility(
                visible: isPassWordLay,
                child: Container(
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
              ),
              Visibility(
                visible: !isOtpLayout,
                child: Container(
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
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                margin: EdgeInsets.only(top: 32),
                height: 45,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: ColorResources.LIGHT_BLUE,
                  child: Text(
                    isPassWordLay == true
                        ? 'SUBMIT PASSWORD'
                        : isOtpLayout == false
                            ? "GET OTP"
                            : "SUBMIT OTP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 0.8),
                  ),
                  onPressed: () {
                    if (isOtpLayout == false) {
                      this.getOTPApi(context, mobileController.text);
                    } else {
                      if (isPassWordLay == false) {
                        print(otpStr +" "+" "+ enteredOtpStr);
                        if (otpStr == enteredOtpStr) {
                          setState(() {
                            isPassWordLay = true;
                          });
                        } else {
                          showUserSnak('Please enter valid OTP', false);
                        }
                      } else {
                        if (passWordController.text.isEmpty) {
                          showUserSnak('Please enter password', false);
                        } else {
                          this.forgotPassWord(context, mobileController.text,
                              otpStr, passWordController.text);
                        }
                      }
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
      ),
    );
  }
}
