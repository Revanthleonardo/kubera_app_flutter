import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/CountModel.dart';
import 'package:kubera_app/Models/LoginResponse.dart';
import 'package:kubera_app/Models/TreeModel.dart';
import 'package:kubera_app/Models/WalletModel.dart';
import 'package:kubera_app/Navigation/BottomNavigation.dart';
import 'package:kubera_app/Util/AppUtils.dart';

import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class TreePage extends StatefulWidget {
  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {
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
  TreeModel _treeModel;
  WalletModel _walletModel;
  CountModel _countModel;
  String userLevel = '';
  List<String> userIDS = [];
  List<String> userNames = [];
  int selectedIndex = 0;

  String mainUserId = '';
  String mainUserLevel = '';
  int referCount = 0;
  LoginResponse _loginResponse;
  String passWord = '';
  _loadInitial() async {
    var _userName = await SharedPreference().getUserName();
    var _mobileNo = await SharedPreference().getMobileNo();
    var _userID = await SharedPreference().getUserId();
    var _passWord = await SharedPreference().getUserPassWord();
    setState(() {
      userName = _userName;
      mobileNo = _mobileNo;
      userID = _userID;
      mainUserId = _userID;
      passWord = _passWord;
      this.getUserLevel(context, userID);
      this.getReferelCount(context, userID);
    });
  }

  getUserLevel(BuildContext context, String userID) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getWalletDetails(userID);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _walletModel = walletModelFromJson(vStatus);
            if (_walletModel.walletApi != null &&
                _walletModel.walletApi.length > 0) {
              userLevel = _walletModel.walletApi[0].level == null
                  ? '1'
                  : _walletModel.walletApi[0].level;

              if (mainUserLevel.isEmpty) {
                mainUserLevel = _walletModel.walletApi[0].level == null
                    ? '1'
                    : _walletModel.walletApi[0].level;
              }
              this.getTreeDetails(context, userID, userLevel, userName);
            } else {
              _treeModel = null;
            }
          } else {
            _walletModel == null;
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

  getReferelCount(BuildContext context, String userID) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getReferelCount(userID);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _countModel = countModelFromJson(vStatus);
            if (_countModel.viewAvgCountApi != null &&
                _countModel.viewAvgCountApi.length > 0) {
              referCount = _countModel.viewAvgCountApi[0].avgCount == null
                  ? 0
                  : int.parse(_countModel.viewAvgCountApi[0].avgCount);
            } else {
              _countModel = null;
            }
          } else {
            _countModel == null;
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

  getTreeUserLevel(BuildContext context, String userID) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getWalletDetails(userID);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _walletModel = walletModelFromJson(vStatus);
            if (_walletModel.walletApi != null &&
                _walletModel.walletApi.length > 0) {
              userLevel = _walletModel.walletApi[0].level == null
                  ? '1'
                  : _walletModel.walletApi[0].level;
            } else {}
          } else {
            _walletModel == null;
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

  getTreeDetails(
      BuildContext context, String userID, String level, String name) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getTreeDetails(userID, level);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _treeModel = treeModelFromJson(vStatus);
            if (_treeModel.result.toString() == 'success') {
              if (!userIDS.contains(userID)) {
                userIDS.add(userID);
                userNames.add(name);
              }
            } else {
              showUserSnak(list[0]['message'], false);
            }
          } else {
            _treeModel = null;
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

  updateLevelAPI(BuildContext context, String userID) async {
    AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().updateLevel(
      userID,
    );

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            showUserSnak('Your level was updated successfully', true);
            this.loginAPI(context, mobileNo, passWord);
          } else {
            showUserSnak('Your level was not updated', false);
          }
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        Navigator.pop(context);
        showUserSnak("Internal Server Error", false);
      });
    }
  }

  loginAPI(BuildContext context, String mobileNo, String passWord) async {
    var vStatus = await ApiInterface().loginAPI(mobileNo, passWord);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];

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
          } else {}
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        //  Navigator.pop(context);
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
          'Referels'.toUpperCase(),
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        index: 2,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 32),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Center(
                    child: Text('Level '.toUpperCase() + userLevel,
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    color: Colors.grey[100]),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage("assets/image/user.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(userName.toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Text('Level '.toUpperCase() + userLevel,
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 10)),
                    )
                  ],
                ),
              ),
              _treeModel != null
                  ? Column(
                      children: [
                        Container(width: 1, height: 50, color: Colors.grey),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 1,
                            color: Colors.grey),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          child: Row(
                            children: [
                              //1st refer
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (_treeModel.viewTreeApi.length > 0) {
                                      userName = _treeModel.viewTreeApi[0].name;
                                      if (userIDS.length < 3) {
                                        setState(() {
                                          selectedIndex += 1;
                                        });
                                        this.getTreeDetails(
                                            context,
                                            _treeModel.viewTreeApi[0].userId,
                                            _treeModel.viewTreeApi[0].level,
                                            _treeModel.viewTreeApi[0].name);
                                        this.getTreeUserLevel(context,
                                            _treeModel.viewTreeApi[0].userId);
                                      } else {
                                        showUserSnak(
                                            'You cannot see after stage 3 referels',
                                            false);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 1,
                                            height: 50,
                                            color: Colors.grey),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5.0,
                                                ),
                                              ],
                                              color: Colors.grey[100]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/image/user.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              0
                                                          ? _treeModel
                                                              .viewTreeApi[0]
                                                              .name
                                                          : 'No User',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 8)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              0
                                                          ? _treeModel
                                                              .viewTreeApi[0]
                                                              .referralNumber
                                                              .trim()
                                                          : '',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 7)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //2nd refer
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (_treeModel.viewTreeApi.length > 1) {
                                      userName = _treeModel.viewTreeApi[1].name;
                                      if (userIDS.length < 3) {
                                        setState(() {
                                          selectedIndex += 1;
                                        });
                                        this.getTreeDetails(
                                            context,
                                            _treeModel.viewTreeApi[1].userId,
                                            _treeModel.viewTreeApi[1].level,
                                            _treeModel.viewTreeApi[1].name);
                                        this.getTreeUserLevel(context,
                                            _treeModel.viewTreeApi[1].userId);
                                      } else {
                                        showUserSnak(
                                            'You cannot see after stage 3 referels',
                                            false);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 1,
                                            height: 50,
                                            color: Colors.grey),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5.0,
                                                ),
                                              ],
                                              color: Colors.grey[100]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/image/user.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              1
                                                          ? _treeModel
                                                              .viewTreeApi[1]
                                                              .name
                                                          : 'No User',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 8)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              1
                                                          ? _treeModel
                                                              .viewTreeApi[1]
                                                              .referralNumber
                                                          : '',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 7)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //3nd refer
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (_treeModel.viewTreeApi.length > 2) {
                                      userName = _treeModel.viewTreeApi[2].name;
                                      if (userIDS.length < 3) {
                                        setState(() {
                                          selectedIndex += 1;
                                        });
                                        this.getTreeDetails(
                                            context,
                                            _treeModel.viewTreeApi[2].userId,
                                            _treeModel.viewTreeApi[2].level,
                                            _treeModel.viewTreeApi[2].name);
                                        this.getTreeUserLevel(context,
                                            _treeModel.viewTreeApi[2].userId);
                                      } else {
                                        showUserSnak(
                                            'You cannot see after stage 3 referels',
                                            false);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 1,
                                            height: 50,
                                            color: Colors.grey),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5.0,
                                                ),
                                              ],
                                              color: Colors.grey[100]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/image/user.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              2
                                                          ? _treeModel
                                                              .viewTreeApi[2]
                                                              .name
                                                          : 'No User',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 8)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              2
                                                          ? _treeModel
                                                              .viewTreeApi[2]
                                                              .referralNumber
                                                          : '',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 7)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //4nd refer
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (_treeModel.viewTreeApi.length > 3) {
                                      userName = _treeModel.viewTreeApi[3].name;
                                      if (userIDS.length < 3) {
                                        setState(() {
                                          selectedIndex += 1;
                                        });
                                        this.getTreeDetails(
                                            context,
                                            _treeModel.viewTreeApi[3].userId,
                                            _treeModel.viewTreeApi[3].level,
                                            _treeModel.viewTreeApi[3].name);
                                        this.getTreeUserLevel(context,
                                            _treeModel.viewTreeApi[3].userId);
                                      } else {
                                        showUserSnak(
                                            'You cannot see after stage 3 referels',
                                            false);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 4),
                                    child: Column(
                                      children: [
                                        Container(
                                            width: 1,
                                            height: 50,
                                            color: Colors.grey),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.22,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5.0,
                                                ),
                                              ],
                                              color: Colors.grey[100]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/image/user.png",
                                                  width: 25,
                                                  height: 25,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              3
                                                          ? _treeModel
                                                              .viewTreeApi[3]
                                                              .name
                                                          : 'No user',
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 8)),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0.0),
                                                  child: Text(
                                                      _treeModel.viewTreeApi
                                                                  .length >
                                                              3
                                                          ? _treeModel
                                                              .viewTreeApi[3]
                                                              .referralNumber
                                                          : '',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                          fontSize: 7)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Container(
                      child: Text('No referred user found'.toUpperCase(),
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 16)),
                    ),
              Visibility(
                visible:
                    mainUserLevel.isNotEmpty && int.parse(mainUserLevel) >= 2
                        ? false
                        : true,
                child: InkWell(
                  onTap: () {
                    this.updateLevelAPI(context, mainUserId);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    decoration: BoxDecoration(
                        color: userLevel != null &&
                                userLevel.isNotEmpty &&
                                referCount >= 84 &&
                                userLevel == '1'
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text('Level 2',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14)))),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.lock, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    mainUserLevel.isNotEmpty && int.parse(mainUserLevel) >= 3
                        ? false
                        : true,
                child: InkWell(
                  onTap: () {
                    this.updateLevelAPI(context, mainUserId);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    decoration: BoxDecoration(
                        color: userLevel != null &&
                                userLevel.isNotEmpty &&
                                referCount >= 84 &&
                                userLevel == '2'
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text('Level 3',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14)))),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.lock, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    mainUserLevel.isNotEmpty && int.parse(mainUserLevel) >= 4
                        ? false
                        : true,
                child: InkWell(
                  onTap: () {
                    this.updateLevelAPI(context, mainUserId);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    decoration: BoxDecoration(
                        color: userLevel != null &&
                                userLevel.isNotEmpty &&
                                referCount >= 84 &&
                                userLevel == '3'
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text('Level 4',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 14)))),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.lock, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _treeModel != null &&
                        _treeModel.viewTreeApi != null &&
                        _treeModel.viewTreeApi.length > 0
                    ? true
                    : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (selectedIndex >= 0) {
                          this.getUserLevel(
                            context,
                            userIDS[selectedIndex - 1],
                          );
                        }

                        setState(() {
                          if (selectedIndex >= 0) {
                            selectedIndex -= 1;
                            userName = userNames[selectedIndex];
                          }
                        });
                      },
                      child: Icon(
                        Icons.arrow_left,
                        size: 60,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (selectedIndex <= 2) {
                          this.getUserLevel(
                            context,
                            userIDS[selectedIndex + 1],
                          );
                        }

                        setState(() {
                          if (selectedIndex <= 2) {
                            selectedIndex += 1;
                            userName = userNames[selectedIndex];
                          }
                        });
                      },
                      child: Icon(
                        Icons.arrow_right,
                        size: 60,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
