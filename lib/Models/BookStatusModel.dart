// To parse this JSON data, do
//
//     final bookStatusModel = bookStatusModelFromJson(jsonString);

import 'dart:convert';

BookStatusModel bookStatusModelFromJson(String str) => BookStatusModel.fromJson(json.decode(str));

String bookStatusModelToJson(BookStatusModel data) => json.encode(data.toJson());

class BookStatusModel {
    BookStatusModel({
        this.api,
        this.result,
        this.getPaymentDetailsForUserWithBookApi,
        this.bookDataApi,
    });

    String api;
    String result;
    List<GetPaymentDetailsForUserWithBookApi> getPaymentDetailsForUserWithBookApi;
    List<BookData> bookDataApi;

    factory BookStatusModel.fromJson(Map<String, dynamic> json) => BookStatusModel(
        api: json["api"],
        result: json["result"],
        getPaymentDetailsForUserWithBookApi: List<GetPaymentDetailsForUserWithBookApi>.from(json["get_payment_details_for_user_with_book_api"].map((x) => GetPaymentDetailsForUserWithBookApi.fromJson(x))),
        bookDataApi: List<BookData>.from(json["book_data_api"].map((x) => BookData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "get_payment_details_for_user_with_book_api": List<dynamic>.from(getPaymentDetailsForUserWithBookApi.map((x) => x.toJson())),
        "book_data_api": List<dynamic>.from(bookDataApi.map((x) => x.toJson())),
    };
}

class BookData {
    BookData({
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

    factory BookData.fromJson(Map<String, dynamic> json) => BookData(
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

class GetPaymentDetailsForUserWithBookApi {
    GetPaymentDetailsForUserWithBookApi({
        this.paymentId,
        this.userId,
        this.bookId,
        this.paymentDate,
        this.paymentIdInstamojo,
        this.paymentRequestIdInstamojo,
        this.status,
    });

    String paymentId;
    String userId;
    String bookId;
    String paymentDate;
    String paymentIdInstamojo;
    String paymentRequestIdInstamojo;
    String status;

    factory GetPaymentDetailsForUserWithBookApi.fromJson(Map<String, dynamic> json) => GetPaymentDetailsForUserWithBookApi(
        paymentId: json["payment_id"],
        userId: json["user_id"],
        bookId: json["book_id"],
        paymentDate: json["payment_date"],
        paymentIdInstamojo: json["payment_id_instamojo"],
        paymentRequestIdInstamojo: json["payment_request_id_instamojo"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "user_id": userId,
        "book_id": bookId,
        "payment_date": paymentDate,
        "payment_id_instamojo": paymentIdInstamojo,
        "payment_request_id_instamojo": paymentRequestIdInstamojo,
        "status": status,
    };
}
