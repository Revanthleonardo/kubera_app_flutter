// To parse this JSON data, do
//
//     final countModel = countModelFromJson(jsonString);

import 'dart:convert';

CountModel countModelFromJson(String str) => CountModel.fromJson(json.decode(str));

String countModelToJson(CountModel data) => json.encode(data.toJson());

class CountModel {
    CountModel({
        this.api,
        this.result,
        this.viewAvgCountApi,
    });

    String api;
    String result;
    List<ViewAvgCountApi> viewAvgCountApi;

    factory CountModel.fromJson(Map<String, dynamic> json) => CountModel(
        api: json["api"],
        result: json["result"],
        viewAvgCountApi: List<ViewAvgCountApi>.from(json["view_avg_count_api"].map((x) => ViewAvgCountApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "view_avg_count_api": List<dynamic>.from(viewAvgCountApi.map((x) => x.toJson())),
    };
}

class ViewAvgCountApi {
    ViewAvgCountApi({
        this.avgCount,
    });

    String avgCount;

    factory ViewAvgCountApi.fromJson(Map<String, dynamic> json) => ViewAvgCountApi(
        avgCount: json["avg_count"],
    );

    Map<String, dynamic> toJson() => {
        "avg_count": avgCount,
    };
}
