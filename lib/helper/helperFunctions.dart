import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String userNameKey = "USERNAME";
  static String userEmailKey = "EMAIL";
  static String userLoggedIn = "USERLOGGEDIN";

  static Future<bool> saveUserLoggedIn(bool IsUserLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(userLoggedIn, IsUserLoggedIn);
  }

    static Future<bool> saveUserName(String userName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(userNameKey, userName);
  }

    static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(userEmailKey, userEmail);
  }

//get user data from shared preferences

 static Future<bool> getUserLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getBool(userLoggedIn)!;
  }

  static Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return  await pref.getString(userNameKey)!;
  }

  static Future<String> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(userEmailKey)!;
  }
   
}
