import 'package:shared_preferences/shared_preferences.dart';

class Session {
  String mobile = "auth_token";
  String name = "auth_name";

  Future<void> setAuthToken(bool mobile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(this.mobile, mobile);
  }

  Future<bool> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(this.mobile);
  }

  Future<void> setName(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.name, name);
  }

  Future<String> getName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(this.name);
  }
}
