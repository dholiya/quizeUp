import 'package:shared_preferences/shared_preferences.dart';

class Session {
  String mobile = "auth_token";

  Future<void> setAuthToken(bool mobile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(this.mobile, mobile);
  }

  Future<bool> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(this.mobile);
  }
}
