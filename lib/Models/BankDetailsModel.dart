// To parse this JSON data, do
//
//     final bankDetailsModel = bankDetailsModelFromJson(jsonString);

import 'dart:convert';

BankDetailsModel bankDetailsModelFromJson(String str) => BankDetailsModel.fromJson(json.decode(str));

String bankDetailsModelToJson(BankDetailsModel data) => json.encode(data.toJson());

class BankDetailsModel {
    BankDetailsModel({
        this.api,
        this.result,
        this.bankDetailsDataApi,
    });

    String api;
    String result;
    List<BankDetailsDataApi> bankDetailsDataApi;

    factory BankDetailsModel.fromJson(Map<String, dynamic> json) => BankDetailsModel(
        api: json["api"],
        result: json["result"],
        bankDetailsDataApi: List<BankDetailsDataApi>.from(json["bank_details_data_api"].map((x) => BankDetailsDataApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "bank_details_data_api": List<dynamic>.from(bankDetailsDataApi.map((x) => x.toJson())),
    };
}

class BankDetailsDataApi {
    BankDetailsDataApi({
        this.bankDetailsId,
        this.userId,
        this.accountHolderName,
        this.accountNo,
        this.ifscCode,
        this.bankName,
        this.status,
    });

    String bankDetailsId;
    String userId;
    String accountHolderName;
    String accountNo;
    String ifscCode;
    String bankName;
    String status;

    factory BankDetailsDataApi.fromJson(Map<String, dynamic> json) => BankDetailsDataApi(
        bankDetailsId: json["bank_details_id"],
        userId: json["user_id"],
        accountHolderName: json["account_holder_name"],
        accountNo: json["account_no"],
        ifscCode: json["ifsc_code"],
        bankName: json["bank_name"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "bank_details_id": bankDetailsId,
        "user_id": userId,
        "account_holder_name": accountHolderName,
        "account_no": accountNo,
        "ifsc_code": ifscCode,
        "bank_name": bankName,
        "status": status,
    };
}
