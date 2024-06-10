import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AppHelper extends ChangeNotifier{
  static const storage = FlutterSecureStorage();

  static Future<void> storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }
  static String baseUrl="http://192.168.1.7:8080/api/v1";
  static Future<void> setId(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', value);
  }

// Retrieve an integer value
  static Future<int?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id'); // Return 0 if the key doesn't exist
  }

  static Future<void> setFirstName(String value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', value);
  }

  static Future<String> getFirstName() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('firstName')!;
  }

  static Future<void> setLastName(String value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastName', value);
  }

  static Future<String> getLastName() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('lastName')!;
  }

  static Future<void> setEmail(String value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', value);
  }

  static Future<String> getEmail() async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('email')!;
  }

  static Future<void> setProfile(String value)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile', value);
  }

  static Future<String> getProfile()async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('profile')!;
  }


}