import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/BankDetailsModel.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class BankDetailsPage extends StatefulWidget {
  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController accHolderNameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  String userId = '';
  String mobileNo = '';
  BankDetailsModel _bankDetailsModel;

  _loadInitial() async {
    var _userID = await SharedPreference().getUserId();
    var _mobileNo = await SharedPreference().getMobileNo();
    setState(() {
      userId = _userID;
      mobileNo = _mobileNo;
      this.getMyBankAccountDetails(context, userId);
    });
  }

  updateBankDetailsAPI(
      BuildContext context,
      String userID,
      String accHolderName,
      String accNo,
      String ifscCode,
      String bankName) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface()
        .updateAccDetails(userID, accHolderName, accNo, ifscCode, bankName);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            showUserSnak('Bank details successfully updated', true);
          } else {
            showUserSnak('Please try again after some time', false);
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

  getMyBankAccountDetails(BuildContext context, String userID) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getAccDetails(userID);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _bankDetailsModel = bankDetailsModelFromJson(vStatus);
            if (_bankDetailsModel.bankDetailsDataApi.length > 0) {
              accHolderNameController.text =
                  _bankDetailsModel.bankDetailsDataApi[0].accountHolderName;
              accNoController.text =
                  _bankDetailsModel.bankDetailsDataApi[0].accountNo;
              ifscController.text =
                  _bankDetailsModel.bankDetailsDataApi[0].ifscCode;
              bankNameController.text =
                  _bankDetailsModel.bankDetailsDataApi[0].bankName;
            }
          } else {}
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
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
      ),
      backgroundColor: (flag) ? Colors.black54 : Colors.red,
      duration: Duration(seconds: 2),
    ));
  }

  // bool isValidDetails() {
  //   if (accHolderNameController.text.isEmpty) {
  //     showUserSnak('Please enter account holder name', false);
  //     return false;
  //   } else if (accNoController.text.isEmpty) {
  //     showUserSnak('Please enter account number', false);
  //     return false;
  //   } else if (ifscController.text.isEmpty) {
  //     showUserSnak('Please enter IFSC Code', false);
  //     return false;
  //   } else if (bankNameController.text.isEmpty) {
  //     showUserSnak('Please enter Bank name', false);
  //     return false;
  //   } else
  //     return true;

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorResources.APP_THEME_COLOR,
        centerTitle: true,
        title: Text(
          'BANK ACCOUNT DETAILS'.toUpperCase(),
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    'PLEASE ENTER YOUR BANK ACCOUNT DETAILS'.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 13),
                  ))),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                        controller: accHolderNameController,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            labelText: "Account HolderName",
                            labelStyle: TextStyle(fontSize: 12),
                            hintText: "")),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                        controller: accNoController,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            labelText: "Account No",
                            labelStyle: TextStyle(fontSize: 12),
                            hintText: "")),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                        controller: ifscController,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            labelText: "IFSC Code",
                            labelStyle: TextStyle(fontSize: 12),
                            hintText: "")),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                        controller: bankNameController,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                            labelText: "Bank Name",
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
                        if (accHolderNameController.text.isEmpty) {
                          showUserSnak(
                              'Please enter account holder name'.toUpperCase(),
                              false);
                        } else if (accNoController.text.isEmpty) {
                          showUserSnak('Please enter account number', false);
                        } else if (ifscController.text.isEmpty) {
                          showUserSnak('Please enter IFSC Code', false);
                        } else if (bankNameController.text.isEmpty) {
                          showUserSnak('Please enter Bank name', false);
                        } else {
                          this.updateBankDetailsAPI(
                              context,
                              userId,
                              accHolderNameController.text,
                              accNoController.text,
                              ifscController.text,
                              bankNameController.text);
                        }
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
