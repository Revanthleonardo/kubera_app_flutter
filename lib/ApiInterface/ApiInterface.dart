import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

class ApiInterface {
  //final String base_url = "https://gymtech.besttech.in/kubera/api/";
  final String base_url = "https://kuberaatechnologies.com/api/";
  var dio = Dio();

  Future<String> getCategory() async {
    String url = base_url + 'book_category.php';

    print("End url " + url);
    try {
      var future = http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getCategoryBooks(String catID) async {
    String url = base_url + 'selected_book_category.php';

    print("End url " + url);
    try {
      var future = http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({
            'category_id': catID,
          }));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getAuthorBooks(String catID) async {
    String url = base_url + 'selected_book_author.php';

    print("End url " + url);
    try {
      var future = http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({
            'author_id': catID,
          }));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getMyBooks(String userId) async {
    String url =
        base_url + 'get_payment_details_for_user.php?user_id=' + userId;

    print("End url " + url);
    try {
      var future = http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> checkPurchaseStatus(String userId, String bookId) async {
    String url = base_url + 'get_payment_details_for_user_with_book.php';

    print("End url " + url);
    try {
      var future = http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({
            'user_id': userId,
            "book_id": bookId,
          }));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getTrendingBooks() async {
    String url = base_url + 'trending_book.php';

    print("End url " + url);
    try {
      var future = http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getAuthorsAPI() async {
    String url = base_url + 'book_author.php';

    print("End url " + url);
    try {
      var future = http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getBookListAPI() async {
    String url = base_url + 'book_view.php';

    print("End url " + url);
    try {
      var future = http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> loginAPI(String mobileNo, String passWord) async {
    String url = base_url + 'user_login.php';

    print("End url " + url);
    try {
      var future = await http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({
            'mobile_number': mobileNo,
            'password': passWord,
          }));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> registerApi(String name, String mobileNo, String passWord,
      String email, String otp) async {
    String url = base_url + 'registration.php';

    print("End url " + url);
    try {
      var future = await http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({
            'name': name,
            'mobile_number': mobileNo,
            'password': passWord,
            'email': email,
            'otp': otp
          }));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getOTP_API(
    String mobile_num,
  ) async {
    String url = base_url + 'get_otp.php';

    print("End url " + url);
    try {
      var future = await http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({'mobile_number': mobile_num}));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> purchaseApi(String userId, String bookId) async {
    String url = base_url + 'payment.php';

    print("End url " + url);
    try {
      var future = await http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({'user_id': userId, 'book_id': bookId}));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> updateRefferNo(String userID, String referralNo) async {
    String url = base_url +
        'update_referral_number.php?user_id=' +
        userID +
        '&referral_number=' +
        referralNo;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> updatePassword(String userID, String password) async {
    String url = base_url + 'password_change.php';

    print("End url " + url);
    try {
      var future = await http.post(Uri.encodeFull(url),
          body:
              JsonEncoder().convert({'password': password, 'user_id': userID}));

      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getAccDetails(String userID) async {
    String url = base_url + 'bank_details_view.php';

    print("End url " + url);
    try {
      var future = await http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({'user_id': userID}));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> updateAccDetails(String userID, String accHolderName,
      String accNo, String ifscCode, String bankName) async {
    String url = base_url + 'bank_details_update.php';

    print("End url " + url);
    try {
      var future = await http.post(Uri.encodeFull(url),
          body: JsonEncoder().convert({
            'user_id': userID,
            "account_holder_name": accHolderName,
            "account_no": accNo,
            "ifsc_code": ifscCode,
            "bank_name": bankName
          }));
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getTreeDetails(String userID, String level) async {
    String url =
        base_url + 'view_tree.php?user_id=' + userID + '&level=' + level;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getMsgApi(String userID) async {
    String url = base_url + 'view_message.php?user_id=' + userID;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> sendMsgApi(String userID, String msg) async {
    String url =
        base_url + 'send_message.php?user_id=' + userID + '&message=' + msg;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getWalletDetails(String userID) async {
    String url = base_url + 'wallet_get.php?user_id=' + userID;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> bookPurchaseAPI(
      String userID, String bookId, String paymentID) async {
    String url = base_url +
        'update_payment.php?user_id=' +
        userID +
        '&book_id=' +
        bookId +
        '&payment_id_razorpay=' +
        paymentID;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> updateLevel(
    String userID,
  ) async {
    String url = base_url + 'level_only_update.php?user_id=' + userID;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> getReferelCount(
    String userID,
  ) async {
    String url = base_url + 'view_avg_count.php?user_id=' + userID;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> passWordChangeAPI(
      String mobileNo, String otp, String newPassCode) async {
    String url = base_url +
        'password_change.php?mobile_number=' +
        mobileNo +
        '&otp=' +
        otp +
        '&password=' +
        newPassCode;

    print("End url " + url);
    try {
      var future = await http.get(
        Uri.encodeFull(url),
      );
      var response = await future;
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
