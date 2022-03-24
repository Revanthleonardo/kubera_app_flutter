// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
    WalletModel({
        this.api,
        this.result,
        this.walletApi,
    });

    String api;
    String result;
    List<WalletApi> walletApi;

    factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        api: json["api"],
        result: json["result"],
        walletApi: List<WalletApi>.from(json["wallet_api"].map((x) => WalletApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "wallet_api": List<dynamic>.from(walletApi.map((x) => x.toJson())),
    };
}

class WalletApi {
    WalletApi({
        this.level,
        this.reward,
    });

    String level;
    String reward;

    factory WalletApi.fromJson(Map<String, dynamic> json) => WalletApi(
        level: json["level"],
        reward: json["reward"],
    );

    Map<String, dynamic> toJson() => {
        "level": level,
        "reward": reward,
    };
}
