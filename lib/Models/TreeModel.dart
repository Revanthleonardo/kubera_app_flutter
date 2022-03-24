// To parse this JSON data, do
//
//     final treeModel = treeModelFromJson(jsonString);

import 'dart:convert';

TreeModel treeModelFromJson(String str) => TreeModel.fromJson(json.decode(str));

String treeModelToJson(TreeModel data) => json.encode(data.toJson());

class TreeModel {
    TreeModel({
        this.api,
        this.result,
        this.viewTreeApi,
    });

    String api;
    String result;
    List<ViewTreeApi> viewTreeApi;

    factory TreeModel.fromJson(Map<String, dynamic> json) => TreeModel(
        api: json["api"],
        result: json["result"],
        viewTreeApi: List<ViewTreeApi>.from(json["view_tree_api"].map((x) => ViewTreeApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "view_tree_api": List<dynamic>.from(viewTreeApi.map((x) => x.toJson())),
    };
}

class ViewTreeApi {
    ViewTreeApi({
        this.userId,
        this.name,
        this.referralNumber,
        this.level,
    });

    String userId;
    String name;
    String referralNumber;
    String level;

    factory ViewTreeApi.fromJson(Map<String, dynamic> json) => ViewTreeApi(
        userId: json["user_id"],
        name: json["name"],
        referralNumber: json["referral_number"],
        level: json["level"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "referral_number": referralNumber,
        "level": level,
    };
}
