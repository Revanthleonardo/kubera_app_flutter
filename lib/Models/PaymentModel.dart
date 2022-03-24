// To parse this JSON data, do
//
//     final paymentModel = paymentModelFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentModelFromJson(String str) => PaymentModel.fromJson(json.decode(str));

String paymentModelToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
    PaymentModel({
        this.success,
        this.paymentRequest,
    });

    bool success;
    PaymentRequest paymentRequest;

    factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        success: json["success"],
        paymentRequest: PaymentRequest.fromJson(json["payment_request"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "payment_request": paymentRequest.toJson(),
    };
}

class PaymentRequest {
    PaymentRequest({
        this.id,
        this.phone,
        this.email,
        this.buyerName,
        this.amount,
        this.purpose,
        this.expiresAt,
        this.status,
        this.sendSms,
        this.sendEmail,
        this.smsStatus,
        this.emailStatus,
        this.shorturl,
        this.longurl,
        this.redirectUrl,
        this.webhook,
        this.allowRepeatedPayments,
        this.customerId,
        this.createdAt,
        this.modifiedAt,
    });

    String id;
    String phone;
    String email;
    String buyerName;
    String amount;
    String purpose;
    dynamic expiresAt;
    String status;
    bool sendSms;
    bool sendEmail;
    dynamic smsStatus;
    dynamic emailStatus;
    dynamic shorturl;
    String longurl;
    String redirectUrl;
    String webhook;
    bool allowRepeatedPayments;
    dynamic customerId;
    DateTime createdAt;
    DateTime modifiedAt;

    factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        buyerName: json["buyer_name"],
        amount: json["amount"],
        purpose: json["purpose"],
        expiresAt: json["expires_at"],
        status: json["status"],
        sendSms: json["send_sms"],
        sendEmail: json["send_email"],
        smsStatus: json["sms_status"],
        emailStatus: json["email_status"],
        shorturl: json["shorturl"],
        longurl: json["longurl"],
        redirectUrl: json["redirect_url"],
        webhook: json["webhook"],
        allowRepeatedPayments: json["allow_repeated_payments"],
        customerId: json["customer_id"],
        createdAt: DateTime.parse(json["created_at"]),
        modifiedAt: DateTime.parse(json["modified_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "phone": phone,
        "email": email,
        "buyer_name": buyerName,
        "amount": amount,
        "purpose": purpose,
        "expires_at": expiresAt,
        "status": status,
        "send_sms": sendSms,
        "send_email": sendEmail,
        "sms_status": smsStatus,
        "email_status": emailStatus,
        "shorturl": shorturl,
        "longurl": longurl,
        "redirect_url": redirectUrl,
        "webhook": webhook,
        "allow_repeated_payments": allowRepeatedPayments,
        "customer_id": customerId,
        "created_at": createdAt.toIso8601String(),
        "modified_at": modifiedAt.toIso8601String(),
    };
}
