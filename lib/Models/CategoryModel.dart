// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    CategoryModel({
        this.api,
        this.result,
        this.bookCategoryDataApi,
    });

    String api;
    String result;
    List<BookCategoryDataApi> bookCategoryDataApi;

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        api: json["api"],
        result: json["result"],
        bookCategoryDataApi: List<BookCategoryDataApi>.from(json["book_category_data_api"].map((x) => BookCategoryDataApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "book_category_data_api": List<dynamic>.from(bookCategoryDataApi.map((x) => x.toJson())),
    };
}

class BookCategoryDataApi {
    BookCategoryDataApi({
        this.categoryId,
        this.categoryName,
        this.categoryImagge,
    });

    String categoryId;
    String categoryName;
    String categoryImagge;

    factory BookCategoryDataApi.fromJson(Map<String, dynamic> json) => BookCategoryDataApi(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categoryImagge: json["category_image"],
    );

    Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
    };
}
