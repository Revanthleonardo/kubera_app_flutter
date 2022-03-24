// To parse this JSON data, do
//
//     final authorBookModel = authorBookModelFromJson(jsonString);

import 'dart:convert';

AuthorBookModel authorBookModelFromJson(String str) => AuthorBookModel.fromJson(json.decode(str));

String authorBookModelToJson(AuthorBookModel data) => json.encode(data.toJson());

class AuthorBookModel {
    AuthorBookModel({
        this.api,
        this.result,
        this.selectedBookAuthorApi,
    });

    String api;
    String result;
    List<SelectedBookAuthorApi> selectedBookAuthorApi;

    factory AuthorBookModel.fromJson(Map<String, dynamic> json) => AuthorBookModel(
        api: json["api"],
        result: json["result"],
        selectedBookAuthorApi: List<SelectedBookAuthorApi>.from(json["selected_book_author_api"].map((x) => SelectedBookAuthorApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "selected_book_author_api": List<dynamic>.from(selectedBookAuthorApi.map((x) => x.toJson())),
    };
}

class SelectedBookAuthorApi {
    SelectedBookAuthorApi({
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

    factory SelectedBookAuthorApi.fromJson(Map<String, dynamic> json) => SelectedBookAuthorApi(
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
