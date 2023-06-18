import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataUtils {
  static String? userName;

  static saveUserName(String text) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_name", text);
    loadUserName();
  }

 static loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("user_name");
  }

  setIdForCurUser(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
  }

  autoLogin(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("email", email);
    prefs.setString("password", password);
  }

  static Future<void> saveAutoLogin(bool check) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("autoLogin", check);
  }

  static Future<bool?> getAutoLoginValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("autoLogin");
  }

  static Future<bool?> getLoadState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("loadState");
  }

  static setLoadState(bool check) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("loadState", check);
  }

  Future<String?> getIdForCurUser() async {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> saveThemeMode(int mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("mode", mode);
  }

  static Future<ThemeMode?> getMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? mode = prefs.getInt("mode");
    if (mode == 1) {
      return ThemeMode.light;
    } else if (mode == 2) {
      return ThemeMode.dark;
    } else if (mode == 3) {
      return ThemeMode.system;
    }
    return null;
  }
}
