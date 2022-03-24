import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/AuthorBookModel.dart';
import 'package:kubera_app/Models/LoginResponse.dart';
import 'package:kubera_app/Models/MyBooksModel.dart';
import 'package:kubera_app/Models/PaymentModel.dart';
import 'package:kubera_app/Pages/PDF/PDF_View.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kubera_app/Util/SharedPref.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBookDetailsPage extends StatefulWidget {
  final GetPaymentDetailsForUserApi bookDataApi;
  MyBookDetailsPage({
    Key key,
    this.bookDataApi,
  }) : super(key: key);

  @override
  State<MyBookDetailsPage> createState() => _MyBookDetailsPageState();
}

class _MyBookDetailsPageState extends State<MyBookDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  String userID = '';
  PaymentModel _paymentModel;
  LoginResponse _loginResponse;
  String mobileNo = '', passWord = '';

  _loadInitial() async {
    var _userId = await SharedPreference().getUserId();
    var _mobileNo = await SharedPreference().getMobileNo();
    var _passWord = await SharedPreference().getUserPassWord();
    setState(() {
      userID = _userId;
      mobileNo = _mobileNo;
      passWord = _passWord;
    });
  }

  _refreshOnly() async {}

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true)
          .then((value) => _refreshOnly);
    } else {
      throw 'Could not launch $url';
    }
  }

  purchaseBooksAPI(BuildContext context, String userId, String bookId) async {
    AppUtils.showProgressDialog(context, "Payment processing...");
    var vStatus = await ApiInterface().purchaseApi(userId, bookId);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          Navigator.pop(context);
          _paymentModel = paymentModelFromJson(vStatus);
          if (_paymentModel.success = true) {
            launchURL(_paymentModel.paymentRequest.longurl);
          } else {
            showUserSnak('Something went wrong', false);
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

  _saveUserData(String refNo) async {
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
          'Book Details'.toUpperCase(),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 8,
                      child: CachedNetworkImage(
                          imageUrl: widget.bookDataApi.bookImage,
                          imageBuilder: (context, imageProvider) => Container(
                                width: 130.0,
                                height: 200.0,
                                margin:
                                    EdgeInsets.only(top: 1, left: 1, right: 1),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person)),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.bookDataApi.bookName.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.only(right: 8.0, left: 8),
                            //   child: RatingBar.builder(
                            //     initialRating: 4,
                            //     direction: Axis.horizontal,
                            //     updateOnDrag: false,
                            //     tapOnlyMode: true,
                            //     itemSize: 12,
                            //     itemCount: 5,
                            //     itemPadding:
                            //         EdgeInsets.symmetric(horizontal: 2.0),
                            //     itemBuilder: (context, _) => Icon(
                            //       Icons.star,
                            //       color: Colors.amber,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Text(
                          widget.bookDataApi.authorName,
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 6, bottom: 6, left: 16, right: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.black),
                                child: Text(
                                  widget.bookDataApi.categoryName.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Included 5% GST (1₹)',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 8),
                              height: 35,
                              child: RaisedButton(
                                textColor: Colors.white,
                                color: ColorResources.LIGHT_BLUE,
                                child: Text(
                                  "READ NOW",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return PDFPage(
                                        title: widget.bookDataApi.bookName,
                                        path: widget.bookDataApi.bookPath,
                                      );
                                    }),
                                  );
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '₹ ' + widget.bookDataApi.amount,
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 4, bottom: 4, left: 12, right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.black),
                            child: Text(
                              'Purchased',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DESCRIPTION',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  Text(
                    "Thirukkural    is   the   only   book   that   guides  us  in  all  situations   of  our  life  .This  chapter    shows    the   positivity  of   speaking   good   words .",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Colors.black54),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
