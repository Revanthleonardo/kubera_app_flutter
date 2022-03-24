import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/AuthorBookModel.dart';
import 'package:kubera_app/Models/BooksModel.dart';
import 'package:kubera_app/Navigation/Navigation.dart';
import 'package:kubera_app/Models/CategoryBookModel.dart';
import 'package:kubera_app/Pages/Authors/AuthorBookDetails.dart';
import 'package:kubera_app/Util/AppUtils.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AuthorBookPage extends StatefulWidget {
  final String pageTitle;
  final String autorId;
  AuthorBookPage({
    Key key,
    this.pageTitle,
    this.autorId,
  }) : super(key: key);
  @override
  State<AuthorBookPage> createState() => _AuthorBookPageState();
}

class _AuthorBookPageState extends State<AuthorBookPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BooksModel booksModel;
  CategoryBookModel _categoryBookModel;
  AuthorBookModel _authorBookModel;

  

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  _loadInitial() async {
    print('AuthorID' + widget.autorId);
    this.getBooks_author(context, widget.autorId);
    setState(() {});
  }

  getBooks_author(BuildContext context, String Id) async {
    //AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getAuthorBooks(Id);

    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          // Navigator.pop(context);
          _authorBookModel = authorBookModelFromJson(vStatus);
          if (_authorBookModel.result.toString() == 'success') {
          } else {
            showUserSnak(list[0]['message'], false);
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
          widget.pageTitle,
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
      ),
      drawer: NavigationDrawer(),
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
                child: _authorBookModel != null &&
                        _authorBookModel.selectedBookAuthorApi.length != null
                    ? Container(
                        child: ListView.builder(
                            itemCount:
                                _authorBookModel.selectedBookAuthorApi.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemBuilder: (BuildContext ctxt, int index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return AuthorBookDetailsPage(
                                        bookDataApi: _authorBookModel
                                            .selectedBookAuthorApi[index],
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
                                                  imageUrl: _authorBookModel
                                                      .selectedBookAuthorApi[
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
                                                _authorBookModel
                                                    .selectedBookAuthorApi[
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
                                                _authorBookModel
                                                    .selectedBookAuthorApi[
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
                                                        _authorBookModel
                                                            .selectedBookAuthorApi[
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
                        child: CircularProgressIndicator(
                          color: ColorResources.APP_THEME_COLOR,
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
