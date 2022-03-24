// To parse this JSON data, do
//
//     final authorsModel = authorsModelFromJson(jsonString);

import 'dart:convert';

AuthorsModel authorsModelFromJson(String str) => AuthorsModel.fromJson(json.decode(str));

String authorsModelToJson(AuthorsModel data) => json.encode(data.toJson());

class AuthorsModel {
    AuthorsModel({
        this.api,
        this.result,
        this.bookAuthorDataApi,
    });

    String api;
    String result;
    List<BookAuthorDataApi> bookAuthorDataApi;

    factory AuthorsModel.fromJson(Map<String, dynamic> json) => AuthorsModel(
        api: json["api"],
        result: json["result"],
        bookAuthorDataApi: List<BookAuthorDataApi>.from(json["book_author_data_api"].map((x) => BookAuthorDataApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "book_author_data_api": List<dynamic>.from(bookAuthorDataApi.map((x) => x.toJson())),
    };
}

class BookAuthorDataApi {
    BookAuthorDataApi({
        this.authorId,
        this.authorName,
        this.authorImage,
    });

    String authorId;
    String authorName;
    String authorImage;

    factory BookAuthorDataApi.fromJson(Map<String, dynamic> json) => BookAuthorDataApi(
        authorId: json["author_id"],
        authorName: json["author_name"],
        authorImage: json["author_image"],
    );

    Map<String, dynamic> toJson() => {
        "author_id": authorId,
        "author_name": authorName,
    };
}
