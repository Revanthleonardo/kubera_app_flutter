// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    LoginResponse({
        this.api,
        this.result,
        this.userLoginApi,
        this.referralNumber,
    });

    String api;
    String result;
    UserLoginApi userLoginApi;
    String referralNumber;

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        api: json["api"],
        result: json["result"],
        userLoginApi: UserLoginApi.fromJson(json["user_login_api"]),
        referralNumber: json["referral_number"],
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "user_login_api": userLoginApi.toJson(),
        "referral_number": referralNumber,
    };
}

class UserLoginApi {
    UserLoginApi({
        this.userId,
        this.name,
        this.mobileNumber,
        this.password,
        this.email,
        this.registeredDate,
    });

    String userId;
    String name;
    String mobileNumber;
    String password;
    String email;
    String registeredDate;

    factory UserLoginApi.fromJson(Map<String, dynamic> json) => UserLoginApi(
        userId: json["user_id"],
        name: json["name"],
        mobileNumber: json["mobile_number"],
        password: json["password"],
        email: json["email"],
        registeredDate: json["registered_date"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "mobile_number": mobileNumber,
        "password": password,
        "email": email,
        "registered_date": registeredDate,
    };
}
