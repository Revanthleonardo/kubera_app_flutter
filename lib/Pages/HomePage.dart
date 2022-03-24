import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kubera_app/ApiInterface/ApiInterface.dart';
import 'package:kubera_app/Models/AuthorsModel.dart';
import 'package:kubera_app/Models/CategoryModel.dart';
import 'package:kubera_app/Models/TrendingBookModel.dart';
import 'package:kubera_app/Navigation/BottomNavigation.dart';
import 'package:kubera_app/Navigation/Navigation.dart';
import 'package:kubera_app/Pages/Authors/AuthorsBookList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kubera_app/Pages/Category/BookList.dart';
import 'package:kubera_app/Pages/Library/MyLibrary.dart';
import 'package:kubera_app/Pages/TrendingBookDetails.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:kubera_app/Util/SharedPref.dart';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchCtrl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CategoryModel categoryModel;
  TrendingBookModel trendingBookModel;
  AuthorsModel authorsModel;
  bool trendingViewAll = false;
  bool categoryViewAll = false;
  bool authorViewAll = false;

  String refId = '';

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  _loadInitial() async {
    this.getCategoriesList(context);
    this.getTrendingBookAPI(context);
    this.getAuthorsList(context);
    var _refID = await SharedPreference().getRefferralNo();
    setState(() {
      refId = _refID;
      print('refId' + refId);
    });
  }

  getCategoriesList(
    BuildContext context,
  ) async {
    // AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getCategory();
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          //  Navigator.pop(context);
          categoryModel = categoryModelFromJson(vStatus);
          categoryModel.bookCategoryDataApi =
              categoryModel.bookCategoryDataApi.reversed.toList();
          if (categoryModel.result.toString() == 'success') {
            categoryViewAll =
                categoryModel.bookCategoryDataApi.length > 8 ? true : false;
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

  getTrendingBookAPI(
    BuildContext context,
  ) async {
    // AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getTrendingBooks();
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          //  Navigator.pop(context);
          trendingBookModel = trendingBookModelFromJson(vStatus);
          if (trendingBookModel.result.toString() == 'success') {
            trendingViewAll =
                trendingBookModel.trendingBookDataApi.length > 3 ? true : false;
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

  getAuthorsList(
    BuildContext context,
  ) async {
    // AppUtils.showProgressDialog(context, "Please Wait...");
    var vStatus = await ApiInterface().getAuthorsAPI();
    if ((vStatus.toString() != 'null')) {
      // If the call to the server was successful, parse the JSON
      Future.delayed(Duration(milliseconds: 1)).then((value) {
        setState(() {
          List<dynamic> list = [json.decode(vStatus)];
          //  Navigator.pop(context);
          authorsModel = authorsModelFromJson(vStatus);
          authorsModel.bookAuthorDataApi =
              authorsModel.bookAuthorDataApi.reversed.toList();
          if (authorsModel.result.toString() == 'success') {
            authorViewAll =
                authorsModel.bookAuthorDataApi.length > 4 ? true : false;
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
          'Home'.toUpperCase(),
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14),
        ),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                Share.share(
                    '₹ 7.4 லட்சம் வருமானம், 12 நாட்களில் வெறும் ₹ 20 முதலீட்டில் \n\nIntroduction : https://youtu.be/PxTvowusbBQ \n\nMy Referral ID:' +
                        refId +
                        '\n\nHere is an app link Download application :  https://www.kuberaatechnologies.com/\n\nUser guide : https://youtu.be/bIdyTV_GoOM');
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.share),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return LibraryPage();
                  }),
                );
              },
              child: Image.asset(
                'assets/icons/book_menu.png',
                width: 32,
                height: 32,
              ),
            ),
          )
        ],
      ),
      drawer: NavigationDrawer(),
      bottomNavigationBar: BottomNavigation(
        index: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 28, bottom: 8),
              color: ColorResources.APP_THEME_COLOR,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24, bottom: 28),
                child: TextField(
                  controller: searchCtrl,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    trendingBookModel != null
                        ? Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Spiritual !',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.2),
                                        ),
                                      ),
                                      Visibility(
                                        visible: trendingViewAll,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                return BookPage(
                                                  pageTitle: 'Trending Books'
                                                      .toUpperCase(),
                                                );
                                              }),
                                            );
                                          },
                                          child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 16),
                                              padding: EdgeInsets.only(
                                                  top: 3,
                                                  bottom: 3,
                                                  right: 8,
                                                  left: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.grey[850],
                                              ),
                                              child: Text(
                                                'VIEW ALL',
                                                style: TextStyle(
                                                  fontFamily: 'OpenSans',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              )),
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.34,
                                //    width: MediaQuery.of(context).size.width * 0.9,
                                margin: EdgeInsets.only(top: 8),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: trendingBookModel
                                      .trendingBookDataApi.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return TrendingBookDetailsPage(
                                            bookDataApi: trendingBookModel
                                                .trendingBookDataApi[index],
                                          );
                                        }),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Card(
                                          child: Center(
                                            child: CachedNetworkImage(
                                                imageUrl: trendingBookModel
                                                    .trendingBookDataApi[index]
                                                    .bookImage,
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                      width: 150.0,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.23,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.fill),
                                                      ),
                                                    ),
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                      'assets/image/book_img.jpg',
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.20,
                                                      fit: BoxFit.fill,
                                                    )),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            trendingBookModel
                                                .trendingBookDataApi[index]
                                                .bookName,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'OpenSans',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          trendingBookModel
                                              .trendingBookDataApi[index]
                                              .authorName,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 4,
                                              bottom: 4,
                                              left: 16,
                                              right: 16),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              color: ColorResources
                                                  .APP_THEME_COLOR),
                                          child: Text(
                                            "₹ " +
                                                trendingBookModel
                                                    .trendingBookDataApi[index]
                                                    .amount,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          'Included 5% GST (1₹)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    // Container(
                    //     padding: EdgeInsets.only(top: 12),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: 12.0),
                    //           child: Text(
                    //             'Spiritual',
                    //             style: TextStyle(
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.bold,
                    //                 letterSpacing: 0.2),
                    //           ),
                    //         ),
                    //         Container(
                    //             margin: EdgeInsets.only(right: 16),
                    //             padding: EdgeInsets.only(
                    //                 top: 3, bottom: 3, right: 8, left: 8),
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10),
                    //               color: Colors.grey[850],
                    //             ),
                    //             child: Text(
                    //               'VIEW ALL',
                    //               style: TextStyle(
                    //                 fontFamily: 'OpenSans',
                    //                 fontWeight: FontWeight.w400,
                    //                 color: Colors.white,
                    //                 fontSize: 10,
                    //               ),
                    //             ))
                    //       ],
                    //     )),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.28,
                    //   width: MediaQuery.of(context).size.width * 0.9,
                    //   margin: EdgeInsets.only(top: 8),
                    //   child: ListView.builder(
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: 15,
                    //     itemBuilder: (BuildContext context, int index) =>
                    //         Column(
                    //       children: [
                    //         Card(
                    //           child: Center(
                    //               child: Image.asset(
                    //             'assets/image/book_img.jpg',
                    //             height:
                    //                 MediaQuery.of(context).size.height * 0.20,
                    //             fit: BoxFit.fill,
                    //           )),
                    //         ),
                    //         Text(
                    //           'Book name',
                    //           style: TextStyle(
                    //               fontSize: 14,
                    //               fontFamily: 'OpenSans',
                    //               color: Colors.black,
                    //               fontWeight: FontWeight.w600),
                    //         ),
                    //         Text(
                    //           'Author name',
                    //           style: TextStyle(
                    //               fontSize: 10,
                    //               fontFamily: 'OpenSans',
                    //               fontWeight: FontWeight.w400),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    categoryModel != null
                        ? Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Categories',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.2),
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Container(
                                            margin: EdgeInsets.only(right: 16),
                                            padding: EdgeInsets.only(
                                                top: 3,
                                                bottom: 3,
                                                right: 8,
                                                left: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey[850],
                                            ),
                                            child: Text(
                                              'VIEW ALL',
                                              style: TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            )),
                                      )
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 16, left: 24, right: 24),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: categoryModel
                                          .bookCategoryDataApi.length,
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 24,
                                        mainAxisSpacing: 24,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.4),
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return BookPage(
                                                    pageTitle: categoryModel
                                                        .bookCategoryDataApi[
                                                            index]
                                                        .categoryName
                                                        .toUpperCase(),
                                                    categoryID: categoryModel
                                                        .bookCategoryDataApi[
                                                            index]
                                                        .categoryId,
                                                    autorId: "",
                                                  );
                                                }),
                                              );
                                            });
                                          },
                                          child: Container(
                                            height: 200,
                                            width: 200,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  height: 70,
                                                  child: CachedNetworkImage(
                                                      imageUrl: categoryModel
                                                          .bookCategoryDataApi[
                                                              index]
                                                          .categoryImagge,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                            width: 60.0,
                                                            height: 60.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.person)),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  categoryModel
                                                      .bookCategoryDataApi[
                                                          index]
                                                      .categoryName,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                    fontSize: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      })),
                            ],
                          )
                        : Container(),
                    authorsModel != null
                        ? Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        child: Text(
                                          'Authors',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.2),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 16, left: 24, right: 24),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          authorsModel.bookAuthorDataApi.length,
                                      gridDelegate:
                                          new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 24,
                                        mainAxisSpacing: 24,
                                        childAspectRatio:
                                            MediaQuery.of(context).size.width /
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1.4),
                                      ),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return AuthorBookPage(
                                                    pageTitle: authorsModel
                                                        .bookAuthorDataApi[
                                                            index]
                                                        .authorName
                                                        .toUpperCase(),
                                                    autorId: authorsModel
                                                        .bookAuthorDataApi[
                                                            index]
                                                        .authorId,
                                                  );
                                                }),
                                              );
                                            });
                                          },
                                          child: Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                  color: ColorResources
                                                      .APP_THEME_COLOR),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  height: 70,
                                                  child: CachedNetworkImage(
                                                      imageUrl: authorsModel
                                                          .bookAuthorDataApi[
                                                              index]
                                                          .authorImage,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                            width: 60.0,
                                                            height: 60.0,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 1,
                                                                    left: 1,
                                                                    right: 1),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .rectangle,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          8)),
                                                              image: DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          ),
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.person)),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  authorsModel
                                                      .bookAuthorDataApi[index]
                                                      .authorName,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                    fontSize: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      })),
                              Visibility(
                                visible: false,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  margin: EdgeInsets.only(top: 32, bottom: 16),
                                  height: 40,
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: ColorResources.LIGHT_BLUE,
                                    child: Text(
                                      "View ALL",
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.4),
                                    ),
                                    onPressed: () {},
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Image.asset(
                        "assets/image/comming_soon.png",
                        //   height: 50,
                        // width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                    ),

                    ImageSlideshow(
                      width: double.infinity,
                      height: 200,
                      initialPage: 0,
                      children: [
                        Image.asset(
                          'assets/image/grocery_1.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/grocery_2.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/grocery_3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ],
                      isLoop: false,
                    ),

                    ImageSlideshow(
                      width: double.infinity,
                      height: 200,
                      initialPage: 0,
                      children: [
                        Image.asset(
                          'assets/image/fashion_1.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/fashion_2.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/fashion_3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ],
                      isLoop: false,
                    ),

                    ImageSlideshow(
                      width: double.infinity,
                      height: 200,
                      initialPage: 0,
                      children: [
                        Image.asset(
                          'assets/image/beauty_1.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/beauty_2.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/beauty_3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ],
                      isLoop: false,
                    ),

                    ImageSlideshow(
                      width: double.infinity,
                      height: 200,
                      initialPage: 0,
                      children: [
                        Image.asset(
                          'assets/image/home_1.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/home_2.jpg',
                          fit: BoxFit.cover,
                        ),
                        Image.asset(
                          'assets/image/home_3.jpg',
                          fit: BoxFit.cover,
                        ),
                      ],
                      isLoop: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
