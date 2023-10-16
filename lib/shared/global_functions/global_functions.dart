import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class GlobalFunctions {
  static Future<void> setFcmToken({required String token}) async {
    await GetStorage().write('token', token);
  }

  static String getFcmToken() {
    String? token = GetStorage().read<String>('token');
    return token!;
  }

  static Future<void> setIsLoggedIn({required bool isLoggedIn}) async {
    await GetStorage().write('isLoggedIn', isLoggedIn);
    debugPrint(isLoggedIn.toString());
  }

  static bool getIsLoggedIn() {
    bool isLoggedIn = GetStorage().read<bool>('isLoggedIn') ?? false;
    debugPrint('isLoggedIn :  ${isLoggedIn.toString()}');
    return isLoggedIn;
  }
}
