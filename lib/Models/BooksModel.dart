// To parse this JSON data, do
//
//     final booksModel = booksModelFromJson(jsonString);

import 'dart:convert';

BooksModel booksModelFromJson(String str) => BooksModel.fromJson(json.decode(str));

String booksModelToJson(BooksModel data) => json.encode(data.toJson());

class BooksModel {
    BooksModel({
        this.api,
        this.result,
        this.bookDataApi,
    });

    String api;
    String result;
    List<BookDataApi> bookDataApi;

    factory BooksModel.fromJson(Map<String, dynamic> json) => BooksModel(
        api: json["api"],
        result: json["result"],
        bookDataApi: List<BookDataApi>.from(json["book_data_api"].map((x) => BookDataApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "book_data_api": List<dynamic>.from(bookDataApi.map((x) => x.toJson())),
    };
}

class BookDataApi {
    BookDataApi({
        this.bookName,
        this.amount,
        this.bookPath,
        this.trending,
        this.authorName,
        this.categoryName,
    });

    String bookName;
    String amount;
    String bookPath;
    String trending;
    String authorName;
    String categoryName;

    factory BookDataApi.fromJson(Map<String, dynamic> json) => BookDataApi(
        bookName: json["book_name"],
        amount: json["amount"],
        bookPath: json["book_path"],
        trending: json["trending"],
        authorName: json["author_name"],
        categoryName: json["category_name"],
    );

    Map<String, dynamic> toJson() => {
        "book_name": bookName,
        "amount": amount,
        "book_path": bookPath,
        "trending": trending,
        "author_name": authorName,
        "category_name": categoryName,
    };
}
