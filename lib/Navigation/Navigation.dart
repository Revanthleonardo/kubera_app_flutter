import 'package:flutter/material.dart';
import 'package:kubera_app/Pages/HomePage.dart';
import 'package:kubera_app/Pages/Library/MyLibrary.dart';
import 'package:kubera_app/Pages/Login.dart';
import 'package:kubera_app/Pages/Profile/BankDetails.dart';
import 'package:kubera_app/Pages/Profile/MyRefferalPage.dart';
import 'package:kubera_app/Pages/Profile/ProfilePage.dart';
import 'package:kubera_app/Pages/Profile/WalletPage.dart';
import 'package:kubera_app/Pages/Support/SupportPagw.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class NavigationDrawer extends StatefulWidget {
  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  String userName = '', userMobile = '';

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

  _loadInitial() async {
    var _userName = await SharedPreference().getUserName();
    var _userMobile = await SharedPreference().getMobileNo();

    setState(() {
      userName = _userName;
      userMobile = _userMobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(userName.toUpperCase(), userMobile),
          createDrawerBodyItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }),
                );
              }),
          createDrawerBodyItem(
              icon: Icons.account_circle,
              text: 'Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProfilePage();
                  }),
                );
              }),
          createDrawerBodyItem(
              icon: Icons.book_online,
              text: 'My Library',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LibraryPage();
                  }),
                );
              }),
          createDrawerBodyItem(
              icon: Icons.people,
              text: 'My Referral',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ReferralPage();
                  }),
                );
              }),
          createDrawerBodyItem(
              icon: Icons.edit_road,
              text: 'Bank Account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return BankDetailsPage();
                  }),
                );
              }),
          Divider(),
          createDrawerBodyItem(
              icon: Icons.wallet_membership,
              text: 'Wallet',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return WalletPage();
                  }),
                );
              }),
          createDrawerBodyItem(
              icon: Icons.contact_support,
              text: 'Help & Support',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SupportPage();
                  }),
                );
              }),
          createDrawerBodyItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
               logoutUser();
              }),
          Divider(),
          ListTile(
            title: Text('Version : 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

Widget createDrawerBodyItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(
          icon,
          color: ColorResources.APP_THEME_COLOR,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}

Widget createDrawerHeader(String userName, String mobile) {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: ColorResources.APP_THEME_COLOR,
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              Utils.book_icon_path,
              width: 60.0,
              height: 60.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10),
              child: Text(userName,
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14)),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 0.0, left: 8),
            //   child: Text("aravind@gmail.com",
            //       style: TextStyle(
            //           fontFamily: 'OpenSans',
            //           fontWeight: FontWeight.w400,
            //           color: Colors.white,
            //           fontSize: 12)),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 8, bottom: 4),
              child: Text(mobile,
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 12)),
            ),
          ]));
}
