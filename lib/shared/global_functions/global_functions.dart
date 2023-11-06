import 'dart:convert';

import 'package:delivery_man_app/models/RequestInfo/request_info_model.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/out_for_delivery_buttons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/ready_toshipping_buttons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/shipped_buttons.dart';
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

  static Future<void> setUserId({required int id}) async {
    await GetStorage().write('userId', id);
  }

  static int getUserId() {
    int? mobilePhone = GetStorage().read<int>('userId');
    return mobilePhone!;
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

  static Future<void> setAssignVehicleToUserId(
      {required dynamic assignToUserId}) async {
    await GetStorage().write('assignToUserId', assignToUserId);
  }

  static int getAssignVehicleToUserId() {
    int? assignToUserId = GetStorage().read<int>('assignToUserId') ?? -1;
    return assignToUserId;
  }

  static Future<void> setAssignedVehicleId(
      {required dynamic assignedVehicleId}) async {
    await GetStorage().write('assignedVehicleId', assignedVehicleId);
  }

  static int getAssignedVehicleId() {
    int? assignedVehicleId = GetStorage().read<int>('assignedVehicleId');
    return assignedVehicleId!;
  }

  static Future<void> setAssignedVehicleName(
      {required dynamic assignedVehicleName}) async {
    await GetStorage().write('assignedVehicleName', assignedVehicleName);
  }

  static String getAssignedVehicleName() {
    String? assignedVehicleName =
        GetStorage().read<String>('assignedVehicleName');
    return assignedVehicleName!;
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

    data.add(requestInfo);

    var infoListToJson = data.map((e) => e.toJson()).toList();

    String ecodedData = json.encode(infoListToJson);

    await GetStorage().write('requestsInfo', ecodedData);
  }

  static List<RequestInfoModel> getRequestsInfo() {
    final data = GetStorage().read<String>('requestsInfo');
    if (data != null) {
      final decodedData = json.decode(data);
      List<RequestInfoModel> infoListFromJson = List<RequestInfoModel>.from(
          decodedData.map((e) => RequestInfoModel.fromJson(e)));

      return infoListFromJson;
    } else {
      return [];
    }
  }
}
