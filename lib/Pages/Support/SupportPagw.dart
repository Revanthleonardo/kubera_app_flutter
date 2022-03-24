import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/MessageModel.dart';
import 'package:kubera_app/Navigation/BottomNavigation.dart';

import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class SupportPage extends StatefulWidget {
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
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
  MessageModel _messageModel;
  TextEditingController msgController = TextEditingController();

  _loadInitial() async {
    var _userName = await SharedPreference().getUserName();
    var _mobileNo = await SharedPreference().getMobileNo();
    var _userID = await SharedPreference().getUserId();
    setState(() {
      userName = _userName;
      mobileNo = _mobileNo;
      userID = _userID;
      this.getMessageDetails(context, userID);
    });
  }

  getMessageDetails(BuildContext context, String userID) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getMsgApi(userID);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _messageModel = messageModelFromJson(vStatus);
            if (_messageModel.result.toString() == 'success') {
            } else {
              showUserSnak(list[0]['message'], false);
            }
          } else {
            _messageModel = null;
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

  sendMessage(BuildContext context, String userID, String msg) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().sendMsgApi(userID, msg);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            msgController.clear();
            this.getMessageDetails(context, userID);
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
          'Help'.toUpperCase(),
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
      ),
       bottomNavigationBar: BottomNavigation(
        index: 3,
      ),
      body: Container(
        color: Colors.grey[100],
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            _messageModel != null
                ? Expanded(
                    child: ListView.builder(
                        itemCount: _messageModel.viewMessageApi.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ScrollPhysics(),
                        itemBuilder: (BuildContext ctxt, int index) {
                          return chatList(index, _messageModel.viewMessageApi);
                        }),
                  )
                : Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('Any Queries? You can chat with us!'),
                    ),
                  ),
            Container(
              height: 55,
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 12, right: 8),
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 14),
                  )),
                  InkWell(
                    onTap: () {
                      sendMessage(
                          context, userID, msgController.text.toString());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Icon(Icons.send, size: 30, color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chatList(int index, List<ViewMessageApi> data) {
    return Container(
      child: Column(
        crossAxisAlignment: data[index].sentBy == 'user'
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: data[index].sentBy == 'user'
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  'You',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "assets/image/man.png",
                    height: 40,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Container(
              padding: data[index].sentBy == 'user'
                  ? EdgeInsets.only(top: 8, bottom: 8, right: 12)
                  : EdgeInsets.only(top: 8, bottom: 8, left: 12),
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Text(data[index].message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
