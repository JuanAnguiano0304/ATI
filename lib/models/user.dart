import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  void registraToken(var accesToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('accesToken', accesToken);
  }

  static Future<String?> leeToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('accesToken');
  }

  static Future cleanToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('Authorization');
    return pref.remove('accesToken');
  }

  void registraDisplayName(String displayName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('displayName', displayName);
  }

  static Future<String?> leeDisplayName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('displayName');
  }

  static Future cleanDisplayName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove('displayName');
  }

  void registraDisplayEmail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('email', email);
  }

  static Future<String?> leeDisplayEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('email');
  }

  static Future cleanDisplayEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove('email');
  }

  toJson() {}
}

class DataUser {
  User user;
  DataUser({required this.user});
}
