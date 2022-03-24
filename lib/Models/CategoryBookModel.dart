// To parse this JSON data, do
//
//     final categoryBookModel = categoryBookModelFromJson(jsonString);

import 'dart:convert';

CategoryBookModel categoryBookModelFromJson(String str) => CategoryBookModel.fromJson(json.decode(str));

String categoryBookModelToJson(CategoryBookModel data) => json.encode(data.toJson());

class CategoryBookModel {
    CategoryBookModel({
        this.api,
        this.result,
        this.selectedBookCategoryApi,
    });

    String api;
    String result;
    List<SelectedBookCategoryApi> selectedBookCategoryApi;

    factory CategoryBookModel.fromJson(Map<String, dynamic> json) => CategoryBookModel(
        api: json["api"],
        result: json["result"],
        selectedBookCategoryApi: List<SelectedBookCategoryApi>.from(json["selected_book_category_api"].map((x) => SelectedBookCategoryApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "selected_book_category_api": List<dynamic>.from(selectedBookCategoryApi.map((x) => x.toJson())),
    };
}

class SelectedBookCategoryApi {
    SelectedBookCategoryApi({
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

    factory SelectedBookCategoryApi.fromJson(Map<String, dynamic> json) => SelectedBookCategoryApi(
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
