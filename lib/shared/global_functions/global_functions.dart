import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/lang_constants.dart';

class GlobalFunctions {
  static Future<void> setLanLocal({required String lanLocal}) async {
    await GetStorage().write('lang', lanLocal);
  }

  static String getLanLocal() {
    String lanLocal = GetStorage().read<String>('lang') ?? LangConstants.ara;
    return lanLocal;
  }

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

  static Future<void> setMobilePhone({required String mobilePhone}) async {
    await GetStorage().write('mobilePhone', mobilePhone);
  }

  static String getMobilePhone() {
    String? mobilePhone = GetStorage().read<String>('mobilePhone') ?? 'Empty';
    return mobilePhone;
  }

  static Future<void> setName({required String name}) async {
    await GetStorage().write('name', name);
  }

  static String getName() {
    String? name = GetStorage().read<String>('name') ?? 'Empty';
    return name;
  }

  static Future<void> setEmail({required String email}) async {
    await GetStorage().write('email', email);
  }

  static String getEmail() {
    String? email = GetStorage().read<String>('email') ?? 'Empty';
    return email;
  }

  static String orderStatusText({required String inputText}) {
    String text = '';

    switch (inputText) {
      case 'pending':
        {
          text = 'Pending'.tr;
          break;
        }

      case 'processing':
        {
          text = 'Processing'.tr;
          break;
        }

      case 'ready_to_shipping':
        {
          text = 'Ready To Shipping'.tr;
          break;
        }

      case 'shipped':
        {
          text = 'Shipped'.tr;
          break;
        }

      case 'out_for_delivery':
        {
          text = 'Out For Delivery'.tr;
          break;
        }

      case 'delivered':
        {
          text = 'Delivered'.tr;
          break;
        }

      case 'partial_return':
        {
          text = 'Partial Return'.tr;
          break;
        }

      case 'returned':
        {
          text = 'Returned'.tr;
          break;
        }

      case 'failed':
        {
          text = 'Failed'.tr;
          break;
        }

      case 'canceled':
        {
          text = 'Canceled'.tr;
          break;
        }

      case 'canceled_archived':
        {
          text = 'Canceled Archived'.tr;
          break;
        }

      default:
        {
          text = 'New Status';
          break;
        }
    }

    return text;
  }
}
