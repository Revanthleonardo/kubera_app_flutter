import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/Pages/Login.dart';
import 'package:kubera_app/Pages/Profile/BankDetails.dart';
import 'package:kubera_app/Pages/Profile/ChangePassword.dart';
import 'package:kubera_app/Pages/Profile/TermsPage.dart';
import 'package:kubera_app/Pages/Support/SupportPagw.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyRefferalPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  void logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return LoginPage();
      }),
    );
  }

  String userName = '';
  String mobileNo = '';

  _loadInitial() async {
    var _userName = await SharedPreference().getUserName();
    var _mobileNo = await SharedPreference().getMobileNo();
    setState(() {
      userName = _userName;
      mobileNo = _mobileNo;
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
          'PROFILE',
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
                height: MediaQuery.of(context).size.height * .3,
                color: ColorResources.APP_THEME_COLOR,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/icon.png',
                        width: 100.0,
                        height: 100.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 10),
                        child: Text(userName.toUpperCase(),
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 14)),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 4.0, left: 8, bottom: 4),
                        child: Text(mobileNo,
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 12)),
                      ),
                    ])),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ReferralPage();
                      }),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  color: ColorResources.APP_THEME_COLOR,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'My Referral',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return BankDetailsPage();
                      }),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.edit_road,
                                  color: ColorResources.APP_THEME_COLOR,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Bank Account',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                        fontSize: 14),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 16.0, left: 12),
                //   child: Column(
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Row(
                //             children: [
                //               Icon(
                //                 Icons.notifications,
                //                 color: ColorResources.APP_THEME_COLOR,
                //                 size: 30,
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.only(left: 16.0),
                //                 child: Text(
                //                   'Notifications',
                //                   style: TextStyle(
                //                       fontFamily: 'OpenSans',
                //                       fontWeight: FontWeight.w400,
                //                       color: Colors.black87,
                //                       fontSize: 14),
                //                 ),
                //               )
                //             ],
                //           ),
                //           Padding(
                //             padding: const EdgeInsets.only(right: 8.0),
                //             child: Icon(
                //               Icons.arrow_right,
                //               size: 30,
                //             ),
                //           )
                //         ],
                //       ),
                //       Container(
                //         margin: EdgeInsets.only(top: 16),
                //         width: MediaQuery.of(context).size.width,
                //         height: 1,
                //         color: Colors.black38,
                //       )
                //     ],
                //   ),
                // ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return TermsPage();
                      }),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.help,
                                  color: ColorResources.APP_THEME_COLOR,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text('Terms & Conditions'),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SupportPage();
                      }),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.help_center,
                                  color: ColorResources.APP_THEME_COLOR,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text('Help & Support'),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  ),
                ),
                
                InkWell(
                  onTap: () {
                    logoutUser();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: ColorResources.APP_THEME_COLOR,
                                  size: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text('Logout'),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.arrow_right,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
