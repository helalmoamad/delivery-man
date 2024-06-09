import 'dart:convert';
import 'package:delivery_man_app/models/RequestInfo/request_info_model.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/out_for_delivery_buttons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/ready_toshipping_buttons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/shipped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/lang_constants.dart';

class GlobalFunctions {
  static SharedPreferences prefs = Get.find<SharedPreferences>();

  static Future<void> reloadPrefs() async {
    await prefs.reload();
  }

  static Future<void> setLanLocal({required String lanLocal}) async {
    await prefs.setString('lang', lanLocal);
  }

  static String getLanLocal() {
    String lanLocal = prefs.getString('lang') ?? LangConstants.ara;

    return lanLocal;
  }

  static Future<void> setFcmToken({required String token}) async {
    await prefs.setString('token', token);
  }

  static String getFcmToken() {
    String? token = prefs.getString('token') ?? '';

    return token;
  }

  static Future<void> setIsLoggedIn({required bool isLoggedIn}) async {
    await prefs.setBool('isLoggedIn', isLoggedIn);
    debugPrint(isLoggedIn.toString());
  }

  static bool getIsLoggedIn() {
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    debugPrint('isLoggedIn :  ${isLoggedIn.toString()}');
    return isLoggedIn;
  }

  static Future<void> setUserId({required int id}) async {
    await prefs.setInt('userId', id);
  }

  static int getUserId() {
    int? mobilePhone = prefs.getInt('userId');
    return mobilePhone!;
  }

  static Future<void> setMobilePhone({required String mobilePhone}) async {
    await prefs.setString('mobilePhone', mobilePhone);
  }

  static String getMobilePhone() {
    String? mobilePhone = prefs.getString('mobilePhone') ?? 'Empty';
    return mobilePhone;
  }

  static Future<void> setName({required String name}) async {
    await prefs.setString('name', name);
  }

  static String getName() {
    String? name = prefs.getString('name') ?? 'Empty';
    return name;
  }

  static Future<void> setEmail({required String email}) async {
    await prefs.setString('email', email);
  }

  static String getEmail() {
    String? email = prefs.getString('email') ?? 'Empty';
    return email;
  }

  static Future<void> setAssignVehicleToUserId(
      {required int assignToUserId}) async {
    await prefs.setInt('assignToUserId', assignToUserId);
  }

  static int getAssignVehicleToUserId() {
    int assignToUserId = prefs.getInt('assignToUserId') ?? -1;
    return assignToUserId;
  }

  static Future<void> setAssignedVehicleId(
      {required int assignedVehicleId}) async {
    await prefs.setInt('assignedVehicleId', assignedVehicleId);
  }

  static int getAssignedVehicleId() {
    int assignedVehicleId = prefs.getInt('assignedVehicleId') ?? -1;
    return assignedVehicleId;
  }

  static Future<void> setAssignedVehicleName(
      {required String assignedVehicleName}) async {
    await prefs.setString('assignedVehicleName', assignedVehicleName);
  }

  static String getAssignedVehicleName() {
    String assignedVehicleName = prefs.getString('assignedVehicleName') ?? '';
    return assignedVehicleName;
  }

  static Future<void> setisForAssignOrderToMe(
      {required bool isForAssignOrderToMe}) async {
    await prefs.setBool('isForAssignOrderToMe', isForAssignOrderToMe);
  }

  static bool getisForAssignOrderToMe() {
    bool? isForAssignOrderToMe = prefs.getBool('isForAssignOrderToMe') ?? false;
    return isForAssignOrderToMe;
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

  static Widget chooseStatusButtons({required String inputText}) {
    switch (inputText) {
      case 'ready_to_shipping':
        {
          return ReadyToShippingButtons();
        }

      case 'shipped':
        {
          return ShippedButtons();
        }

      case 'out_for_delivery':
        {
          return OutForDeliveryButtons();
        }

      default:
        {
          return Container();
        }
    }
  }

  static String paidStatusText({required String inputText}) {
    String text = '';

    switch (inputText) {
      case 'paid':
        {
          text = 'Paid'.tr;
          break;
        }

      case 'partial_paid':
        {
          text = 'Partial Paid'.tr;
          break;
        }

      case 'unpaid':
        {
          text = 'UnPaid'.tr;
          break;
        }

      default:
        {
          text = 'New Paid Status';
          break;
        }
    }
    return text;
  }

  static Future<void> setRequestInfo(
      {required RequestInfoModel requestInfo}) async {
    List<RequestInfoModel> data = getRequestsInfo();

    if (data.length >= 40) {
      data.removeAt(data.length - 1);
      data.insert(0, requestInfo);
    } else {
      data.insert(0, requestInfo);
    }

    var infoListToJson = data.map((e) => e.toJson()).toList();

    String encodedData = json.encode(infoListToJson);

    await prefs.setString('requestsInfo', encodedData);
  }

  static List<RequestInfoModel> getRequestsInfo() {
    final data = prefs.getString('requestsInfo');
    if (data != null) {
      final decodedData = json.decode(data);
      List<RequestInfoModel> infoListFromJson = List<RequestInfoModel>.from(
          decodedData.map((e) => RequestInfoModel.fromJson(e)));

      return infoListFromJson;
    } else {
      return [];
    }
  }

  static Future<void> deleteRequestInfo({required int index}) async {
    List<RequestInfoModel> data = getRequestsInfo();

    data.removeAt(index);

    var infoListToJson = data.map((e) => e.toJson()).toList();

    String encodedData = json.encode(infoListToJson);

    await prefs.setString('requestsInfo', encodedData);
  }

  static Future<void> deleteAllRequestsInfo() async {
    await prefs.remove('requestsInfo');
  }
}
