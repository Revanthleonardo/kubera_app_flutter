import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/WalletModel.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
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
  WalletModel _walletModel;

  _loadInitial() async {
    var _userName = await SharedPreference().getUserName();
    var _mobileNo = await SharedPreference().getMobileNo();
    var _userID = await SharedPreference().getUserId();
    setState(() {
      userName = _userName;
      mobileNo = _mobileNo;
      userID = _userID;
      this.getWalletDetailsApi(context, userID);
    });
  }

  getWalletDetailsApi(BuildContext context, String userID) async {
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
                  'Your wallet amount'.toUpperCase(),
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
                    height: 45,
                    decoration: BoxDecoration(
                        //    borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.blueAccent)),
                    child: Center(
                      child: Text(
                        _walletModel == null &&
                                _walletModel.walletApi != null &&
                                _walletModel.walletApi.length <= 0
                            ? '₹ 0.0'
                            : "₹ " + _walletModel.walletApi[0].reward,
                        style: TextStyle(fontSize: 18),
                      ),
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
                        "Request for withdraw".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 0),
                      ),
                      onPressed: () {
                        showUserSnak('Please complete level 4!', false);
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
}
