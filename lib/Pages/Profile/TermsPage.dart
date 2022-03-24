import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class TermsPage extends StatefulWidget {
  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
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
          'Terms & Conditions'.toUpperCase(),
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
        actions: [],
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
                    'Terms and Conditions'.toUpperCase(),
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14),
                  ))),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "This is an agreement between you and kuberaa. \nPlease read these kuberaa terms & conditions of use, before buying any product or using our service. \nBy using the kuberaa Application, purchasing or using any product, using the application, or using any aspect of the service, we want you to agree to our terms and conditions. \nIf you do not accept our company's policies then you must not use our product or service.Kuberaa Applications is a software that will be available and permits users to buy, download, browse, or use the content on a Supported Devices.\nWe will help you based on the supported devices means a mobile, computer, or other supported electronic devices on which you are authorized to operate the Kuberaa Application.\nKuberaa content is licensed, & not sold to you by the content provider.\nYou Should not remove or modify the contents which we are given for you.\nSome content such as highly enclosed and interactives may not be available to you on all the kuberaa applications.\nAs a kuberaa user you are agree to provide your original identification and other personal information with us (such as your name,Mobile number,bank details or other contact information) it will be stored and kept safe from our side.\nOnce you have made any purchase or any service subscription charges from Kuberaa technologies then you can't reclaim any refund strictly.\nWe may stop providing the Services or any of its features within our sole discretion. We also retain the right to create limits on use and storage and may remove or limit content distribution on the Services.\nTermination,You are free to stop using our Services at any time. We reserve the right to suspend or terminate your access to the Services with or without notice.",
                      style: TextStyle(fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
