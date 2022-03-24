import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/MyBooksModel.dart';
import 'package:kubera_app/Navigation/BottomNavigation.dart';
import 'package:kubera_app/Navigation/Navigation.dart';
import 'package:kubera_app/Pages/Library/MyBooksDetails.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kubera_app/Util/SharedPref.dart';

class LibraryPage extends StatefulWidget {
  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  String userId = '';
  MyBooksModel _myBooksModel;
  bool progressVisible = true;

  _loadInitial() async {
    var _userId = await SharedPreference().getUserId();
    setState(() {
      userId = _userId;
      this.getPurchasedBooks(context, userId);
      print(_userId);
    });
  }

  getPurchasedBooks(BuildContext context, String userID) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getMyBooks(userID);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          if (list[0]['result'].toString() == 'success') {
            _myBooksModel = myBooksModelFromJson(vStatus);
            if (_myBooksModel.result.toString() == 'success') {
            } else {
              showUserSnak(list[0]['message'], false);
            }
          } else {
            progressVisible = false;
            _myBooksModel = new MyBooksModel();
            //  showUserSnak('You have not purchased books yet', false);
          }
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        //  Navigator.pop(context);
        setState(() {
          progressVisible = false;
          _myBooksModel = new MyBooksModel();
        });
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
          'MY LIBRARY',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
      ),
      drawer: NavigationDrawer(),
      bottomNavigationBar: BottomNavigation(
        index: 1,
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 12),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 28, bottom: 8),
              color: ColorResources.APP_THEME_COLOR,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24, bottom: 28, top: 12),
                child: TextField(
                  // controller: searchCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      hintStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.all(8),
                      fillColor: Colors.white),
                ),
              ),
            ),
            Expanded(
                child: _myBooksModel != null &&
                        _myBooksModel.getPaymentDetailsForUserApi != null
                    ? Container(
                        child: ListView.builder(
                            itemCount: _myBooksModel
                                .getPaymentDetailsForUserApi.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemBuilder: (BuildContext ctxt, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return MyBookDetailsPage(
                                        bookDataApi: _myBooksModel
                                            .getPaymentDetailsForUserApi[index],
                                      );
                                    }),
                                  );
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20.0,
                                      ),
                                    ],
                                  ),
                                  child: Card(
                                    shadowColor: Colors.black,
                                    margin: EdgeInsets.only(
                                        top: 16, left: 20, right: 20),
                                    elevation: 8,
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Card(
                                              elevation: 8,
                                              child: CachedNetworkImage(
                                                  imageUrl: _myBooksModel
                                                      .getPaymentDetailsForUserApi[
                                                          index]
                                                      .bookImage,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                        width: 130.0,
                                                        height: 200.0,
                                                        margin: EdgeInsets.only(
                                                            top: 1,
                                                            left: 1,
                                                            right: 1),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          image: DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit:
                                                                  BoxFit.cover),
                                                        ),
                                                      ),
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.person)),
                                            ),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _myBooksModel
                                                    .getPaymentDetailsForUserApi[
                                                        index]
                                                    .bookName
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                _myBooksModel
                                                    .getPaymentDetailsForUserApi[
                                                        index]
                                                    .authorName,
                                                style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 6,
                                                          bottom: 6,
                                                          left: 16,
                                                          right: 16),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: Colors.black),
                                                      child: Text(
                                                        _myBooksModel
                                                            .getPaymentDetailsForUserApi[
                                                                index]
                                                            .categoryName,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'OpenSans',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Text(
                                                  'Thirukkural is the only book that guides us in all situations of our life .',
                                                  style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black54,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       top: 18.0),
                                              //   child: RatingBar.builder(
                                              //     initialRating: 4,
                                              //     direction: Axis.horizontal,
                                              //     updateOnDrag: false,
                                              //     tapOnlyMode: true,
                                              //     itemSize: 14,
                                              //     itemCount: 5,
                                              //     itemPadding:
                                              //         EdgeInsets.symmetric(
                                              //             horizontal: 2.0),
                                              //     itemBuilder: (context, _) =>
                                              //         Icon(
                                              //       Icons.star,
                                              //       color: Colors.amber,
                                              //     ),
                                              //   ),
                                              // )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: progressVisible,
                              child: CircularProgressIndicator(
                                color: ColorResources.APP_THEME_COLOR,
                              ),
                            ),
                            Visibility(
                              visible: !progressVisible,
                              child: Text(
                                'No books were purchased',
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
