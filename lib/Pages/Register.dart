import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/Utils.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController cnfrmPasswordController = TextEditingController();

  bool isOtpLayout = false;
  String otpStr = '';
  String enteredOtpStr = '';
  bool isPasswordVisible = false;
  bool isCnfrmPasswordVisible = false;

  registerAPI(BuildContext context, String name, String mobileNo,
      String emailId, String passWord, String otp) async {
    AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface()
        .registerApi(name, mobileNo, passWord, emailId, otp);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);

          if (list[0]['result'] == 'success') {
            Navigator.pop(context);
          } else {
            showUserSnak('Mobile number is already registered', false);
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

  getOTPApi(BuildContext context, String mobileNo) async {
    AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getOTP_API(mobileNo);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);

          if (list[0]['result'] == 'success') {
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

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool isValidDetails() {
    if (nameController.text.isEmpty) {
      showUserSnak('Please enter Username', false);
      return false;
    } else if (mobileController.text.isEmpty) {
      showUserSnak('Please enter mobile number', false);
      return false;
    } else if (mobileController.text.length <= 9) {
      showUserSnak('Please enter valid mobile number', false);
      return false;
    }
    // else if (emailController.text.isEmpty) {
    //   showUserSnak('Please enter email id', false);
    //   return false;
    // } else if (validateEmail(emailController.text) == false) {
    //   showUserSnak('Please enter valid email id', false);
    //   return false;
    // }
    else if (passWordController.text.isEmpty) {
      showUserSnak('Please enter your password', false);
      return false;
    } else if (cnfrmPasswordController.text.isEmpty) {
      showUserSnak('Please enter your confirm password', false);
      return false;
    } else if (cnfrmPasswordController.text != passWordController.text) {
      showUserSnak('Please enter same password on confirm password', false);
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
              Visibility(
                visible: !isOtpLayout,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Text(
                        'Signup to Continue',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                          controller: nameController,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                              labelText: "NAME",
                              labelStyle: TextStyle(fontSize: 12),
                              hintText: "")),
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
                    // Container(
                    //   margin: EdgeInsets.only(top: 12),
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   child: TextField(
                    //       controller: emailController,
                    //       keyboardType: TextInputType.emailAddress,
                    //       style: TextStyle(fontSize: 12),
                    //       decoration: InputDecoration(
                    //           labelText: "EMAIL ID",
                    //           labelStyle: TextStyle(fontSize: 12),
                    //           hintText: "")),
                    // ),
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
                      margin: EdgeInsets.only(top: 8),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                          controller: cnfrmPasswordController,
                          style: TextStyle(fontSize: 12),
                          obscureText: !isCnfrmPasswordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                              labelText: "CONFIRM PASSWORD",
                              labelStyle: TextStyle(fontSize: 12),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isCnfrmPasswordVisible =
                                          !isCnfrmPasswordVisible;
                                    });
                                  },
                                  child: Icon(isCnfrmPasswordVisible == false
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
                          "REGISTER",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                        onPressed: () {
                          if (isValidDetails()) {
                            this.getOTPApi(context, mobileController.text);
                          }
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
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have account?"),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Sign In',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                  visible: isOtpLayout,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: Text(
                          'Please Enter OTP to verify your mobile no',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        margin: EdgeInsets.only(top: 32),
                        height: 45,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: ColorResources.LIGHT_BLUE,
                          child: Text(
                            "VERIFY",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8),
                          ),
                          onPressed: () {
                            if (otpStr == enteredOtpStr) {
                              this.registerAPI(
                                  context,
                                  nameController.text,
                                  mobileController.text,
                                  emailController.text,
                                  passWordController.text,
                                  otpStr);
                            } else {
                              showUserSnak('Please enter valid OTP', false);
                            }
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isOtpLayout = false;
                            });
                          },
                          child: Text(
                            'Re-enter mobile number',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
