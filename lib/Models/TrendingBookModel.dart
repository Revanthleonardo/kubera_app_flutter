// To parse this JSON data, do
//
//     final trendingBookModel = trendingBookModelFromJson(jsonString);

import 'dart:convert';

TrendingBookModel trendingBookModelFromJson(String str) => TrendingBookModel.fromJson(json.decode(str));

String trendingBookModelToJson(TrendingBookModel data) => json.encode(data.toJson());

class TrendingBookModel {
    TrendingBookModel({
        this.api,
        this.result,
        this.trendingBookDataApi,
    });

    String api;
    String result;
    List<TrendingBookDataApi> trendingBookDataApi;

    factory TrendingBookModel.fromJson(Map<String, dynamic> json) => TrendingBookModel(
        api: json["api"],
        result: json["result"],
        trendingBookDataApi: List<TrendingBookDataApi>.from(json["trending_book_data_api"].map((x) => TrendingBookDataApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "trending_book_data_api": List<dynamic>.from(trendingBookDataApi.map((x) => x.toJson())),
    };
}

class TrendingBookDataApi {
    TrendingBookDataApi({
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

    factory TrendingBookDataApi.fromJson(Map<String, dynamic> json) => TrendingBookDataApi(
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
