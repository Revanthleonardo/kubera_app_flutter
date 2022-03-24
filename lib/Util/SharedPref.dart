import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  final String _userId = "userId";
  final String _userName = "userName";
  final String _mobileNo = "mobileNo";
  final String _passWord = "passWord";
  final String _userEmail = 'emailId';
  final String _referralNo = 'referralNo';

  Future<bool> setuserId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userId, value);
  }

  Future<bool> setMobileNo(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_mobileNo, value);
  }

  Future<bool> setUserName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userName, value);
  }

  Future<bool> setPassWord(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_passWord, value);
  }

  Future<bool> setUserEmail(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userEmail, value);
  }

  Future<bool> setRefferralNo(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_referralNo, value);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId) ?? null;
  }

  Future<String> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_userName) ?? null;
  }

  Future<String> getMobileNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_mobileNo) ?? null;
  }

  Future<String> getUserPassWord() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_passWord) ?? null;
  }

  Future<String> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_userEmail) ?? null;
  }

  Future<String> getRefferralNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_referralNo) ?? null;
  }
}
