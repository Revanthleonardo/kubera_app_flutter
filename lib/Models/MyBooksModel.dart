// To parse this JSON data, do
//
//     final myBooksModel = myBooksModelFromJson(jsonString);

import 'dart:convert';

MyBooksModel myBooksModelFromJson(String str) => MyBooksModel.fromJson(json.decode(str));

String myBooksModelToJson(MyBooksModel data) => json.encode(data.toJson());

class MyBooksModel {
    MyBooksModel({
        this.api,
        this.result,
        this.getPaymentDetailsForUserApi,
    });

    String api;
    String result;
    List<GetPaymentDetailsForUserApi> getPaymentDetailsForUserApi;

    factory MyBooksModel.fromJson(Map<String, dynamic> json) => MyBooksModel(
        api: json["api"],
        result: json["result"],
        getPaymentDetailsForUserApi: List<GetPaymentDetailsForUserApi>.from(json["get_payment_details_for_user_api"].map((x) => GetPaymentDetailsForUserApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "get_payment_details_for_user_api": List<dynamic>.from(getPaymentDetailsForUserApi.map((x) => x.toJson())),
    };
}

class GetPaymentDetailsForUserApi {
    GetPaymentDetailsForUserApi({
        this.paymentId,
        this.paymentDate,
        this.paymentIdInstamojo,
        this.paymentRequestIdInstamojo,
        this.bookId,
        this.bookName,
        this.bookImage,
        this.amount,
        this.bookPath,
        this.trending,
        this.authorId,
        this.authorName,
        this.authorImage,
        this.categoryId,
        this.categoryName,
        this.categoryImage,
    });

    String paymentId;
    String paymentDate;
    String paymentIdInstamojo;
    String paymentRequestIdInstamojo;
    String bookId;
    String bookName;
    String bookImage;
    String amount;
    String bookPath;
    String trending;
    String authorId;
    String authorName;
    String authorImage;
    String categoryId;
    String categoryName;
    String categoryImage;

    factory GetPaymentDetailsForUserApi.fromJson(Map<String, dynamic> json) => GetPaymentDetailsForUserApi(
        paymentId: json["payment_id"],
        paymentDate: json["payment_date"],
        paymentIdInstamojo: json["payment_id_instamojo"],
        paymentRequestIdInstamojo: json["payment_request_id_instamojo"],
        bookId: json["book_id"],
        bookName: json["book_name"],
        bookImage: json["book_image"],
        amount: json["amount"],
        bookPath: json["book_path"],
        trending: json["trending"],
        authorId: json["author_id"],
        authorName: json["author_name"],
        authorImage: json["author_image"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryImage: json["category_image"],
    );

    Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "payment_date": paymentDate,
        "payment_id_instamojo": paymentIdInstamojo,
        "payment_request_id_instamojo": paymentRequestIdInstamojo,
        "book_id": bookId,
        "book_name": bookName,
        "book_image": bookImage,
        "amount": amount,
        "book_path": bookPath,
        "trending": trending,
        "author_id": authorId,
        "author_name": authorName,
        "author_image": authorImage,
        "category_id": categoryId,
        "category_name": categoryName,
        "category_image": categoryImage,
    };
}
