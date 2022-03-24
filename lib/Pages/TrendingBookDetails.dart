import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/BookStatusModel.dart';
import 'package:kubera_app/Models/LoginResponse.dart';
import 'package:kubera_app/Models/PaymentModel.dart';
import 'package:kubera_app/Models/TrendingBookModel.dart';
import 'package:kubera_app/Pages/PDF/PDF_View.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kubera_app/Util/SharedPref.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class TrendingBookDetailsPage extends StatefulWidget {
  final TrendingBookDataApi bookDataApi;
  TrendingBookDetailsPage({
    Key key,
    this.bookDataApi,
  }) : super(key: key);

  @override
  State<TrendingBookDetailsPage> createState() =>
      _TrendingBookDetailsPageState();
}

class _TrendingBookDetailsPageState extends State<TrendingBookDetailsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _loadInitial();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(int amount, String bookName, String mobile) async {
    var options = {
      'key': 'rzp_live_ini2fjMjUJcWNX',
      'amount': amount,
      'name': bookName,
      'description': 'Book',
      'prefill': {'contact': mobile, 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    purchaseBooksAPI(
        context, userID, widget.bookDataApi.bookId, response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('RazorRes: ' + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  String userID = '', userMobile = '';
  PaymentModel _paymentModel;
  BookStatusModel _bookStatusModel;
  String passWord = '';
  LoginResponse _loginResponse;

  _loadInitial() async {
    var _userId = await SharedPreference().getUserId();
    var _userMobile = await SharedPreference().getMobileNo();
    var _passWord = await SharedPreference().getUserPassWord();
    setState(() {
      userID = _userId;
      userMobile = _userMobile;
       passWord = _passWord;
      print(userID + widget.bookDataApi.bookId);
      this.checkBookStatus(context, userID, widget.bookDataApi.bookId);
    });
  }

  bool isPurchased = false;

  checkBookStatus(BuildContext context, String userId, String bookId) async {
    //  AppUtils.showProgressDialog(context, "Payment processing...");
    var vStatus = await ApiInterface().checkPurchaseStatus(userId, bookId);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          //   Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _bookStatusModel = bookStatusModelFromJson(vStatus);
            if (_bookStatusModel
                    .getPaymentDetailsForUserWithBookApi[0].status ==
                "success") {
              isPurchased = false;
            } else {
              isPurchased = true;
            }
          } else {
            isPurchased = false;
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

  purchaseBooksAPI(BuildContext context, String userId, String bookId,
      String paymentID) async {
    //  AppUtils.showProgressDialog(context, "Payment processing...");
    var vStatus =
        await ApiInterface().bookPurchaseAPI(userId, bookId, paymentID);
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          //   Navigator.pop(context);

          if (list[0]["result"].toString() == "success") {
            isPurchased = true;
            showUserSnak('Book purchased successfully', true);
            this.loginAPI(context, userMobile, passWord);
          } else {
            showUserSnak('Book purchased not successfully', false);
          }
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        //   Navigator.pop(context);
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
                                  isPurchased == false
                                      ? "PURCHASE"
                                      : "READ NOW",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                onPressed: () {
                                  if (isPurchased == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return PDFPage(
                                          title: widget.bookDataApi.bookName,
                                          path: widget.bookDataApi.bookPath,
                                        );
                                      }),
                                    );
                                  } else {
                                    openCheckout(
                                        int.parse(widget.bookDataApi.amount) *
                                            100,
                                        widget.bookDataApi.bookName,
                                        userMobile);
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '₹ ' +
                                    double.parse(widget.bookDataApi.amount)
                                        .toStringAsFixed(2),
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
                              isPurchased == false
                                  ? 'Not-Purchased'
                                  : "Purchased",
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
