// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

MessageModel messageModelFromJson(String str) => MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
    MessageModel({
        this.api,
        this.result,
        this.viewMessageApi,
    });

    String api;
    String result;
    List<ViewMessageApi> viewMessageApi;

    factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        api: json["api"],
        result: json["result"],
        viewMessageApi: List<ViewMessageApi>.from(json["view_message_api"].map((x) => ViewMessageApi.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "api": api,
        "result": result,
        "view_message_api": List<dynamic>.from(viewMessageApi.map((x) => x.toJson())),
    };
}

class ViewMessageApi {
    ViewMessageApi({
        this.messageId,
        this.userId,
        this.message,
        this.sentBy,
        this.date,
        this.time,
        this.status,
    });

    String messageId;
    String userId;
    String message;
    String sentBy;
    DateTime date;
    String time;
    String status;

    factory ViewMessageApi.fromJson(Map<String, dynamic> json) => ViewMessageApi(
        messageId: json["message_id"],
        userId: json["user_id"],
        message: json["message"],
        sentBy: json["sent_by"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "user_id": userId,
        "message": message,
        "sent_by": sentBy,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "status": status,
    };
}
