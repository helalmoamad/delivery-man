import 'dart:convert';
import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/InDeliveryCenterFromReturnButtons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/InTransitButtons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/OutForDeleveryFromReturn.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/OutForReturnButtons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/out_for_delivery_buttons.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/shipped_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/json_serializable.dart';
import '../../views/OrderDetails/status_buttons/canceled_archived_buttons.dart';
import '../../views/OrderDetails/status_buttons/canceled_buttons.dart';
import '../../views/OrderDetails/status_buttons/delivered_buttons.dart';
import '../../views/OrderDetails/status_buttons/failed_buttons.dart';
import '../../views/OrderDetails/status_buttons/partial_return_buttons.dart';
import '../../views/OrderDetails/status_buttons/in_delivery_center_buttons.dart';
import '../../views/OrderDetails/status_buttons/return_buttons.dart';
import '../constants/lang_constants.dart';
import '../constants/order_statuses.dart';

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
  // verificationId

  static Future<void> setToken({required String token}) async {
    await prefs.setString('token', token);
  }

  static Future<void> removeToken() async {
    await prefs.remove('token');
  }
  static String getToken() {
    String? token = prefs.getString('token') ?? '';

    return token;
  }

  static Future<void> setChatToken({required String chatToken}) async {
    await prefs.setString('chat_token', chatToken);
  }

  static String getChatToken() {
    String? chatToken = prefs.getString('chat_token') ?? '';

    return chatToken;
  }

  static Future<void> setVerificationId(
      {required String verificationId}) async {
    await prefs.setString('verificationId', verificationId);
  }

  static String? getVerificationId() {
    String? verificationId = prefs.getString('verificationId');

    return verificationId;
  }

  static Future<void> removeVerificationId() async {
    await prefs.remove('verificationId');
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
    int? userId = prefs.getInt('userId');
    return userId ?? 0;
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
    bool? val = prefs.getBool('isForAssignOrderToMe') ?? false;
    return val;
  }

  static Future<void> setIsFromNotifiForNewOrder(
      {required bool isFromNotifiForNewOrder}) async {
    await prefs.setBool(
        'is_from_notifi_for_new_order', isFromNotifiForNewOrder);
  }

  static bool getIsFromNotifiForNewOrder() {
    bool notifiType = prefs.getBool('is_from_notifi_for_new_order') ?? false;

    return notifiType;
  }

  static Future<void> setNotifiType({required String notifiType}) async {
    await prefs.setString('notifi_type', notifiType);
  }

  static String getNotifiType() {
    String notifiType = prefs.getString('notifi_type') ?? '';

    return notifiType;
  }

  static Future<void> setOrderId({required String orderId}) async {
    await prefs.setString('order_id', orderId);
  }

  static String? getOrderId() {
    String? orderId = prefs.getString('order_id');

    return orderId;
  }

  static String orderStatusText({required String inputText}) {
    String text = '';

    switch (inputText) {
      // case OrderStatuses.pending:
      //   {
      //     text = 'Pending'.tr;
      //     break;
      //   }

      // case OrderStatuses.processing:
      //   {
      //     text = 'Processing'.tr;
      //     break;
      //   }

      // case OrderStatuses.readyToShipping:
      //   {
      //     text = 'Ready To Shipping'.tr;
      //     break;
      //   }

      // case OrderStatuses.shipped:
      //   {
      //     text = 'Shipped'.tr;
      //     break;
      //   }
      case OrderStatuses.inDeliveryCenter:
        {
          text = 'In Delivery Center'.tr;
          break;
        }

      case OrderStatuses.outForDelivery:
        {
          text = 'Out For Delivery'.tr;
          break;
        }

      case OrderStatuses.delivered:
        {
          text = 'Delivered'.tr;
          break;
        }

      case OrderStatuses.onHold:
        {
          text = 'On Hold'.tr;
          break;
        }

      case OrderStatuses.partialReturn:
        {
          text = 'Partial Return'.tr;
          break;
        }

      case OrderStatuses.returned:
        {
          text = 'Returned'.tr;
          break;
        }

      case OrderStatuses.failed:
        {
          text = 'Failed'.tr;
          break;
        }

      case OrderStatuses.canceled:
        {
          text = 'Canceled'.tr;
          break;
        }

      case OrderStatuses.canceledArchived:
        {
          text = 'Canceled Archived'.tr;
          break;
        }

      case OrderStatuses.returnedToDeliveryCenter:
        {
          text = 'Out for return'.tr;
          break;
        }
      case OrderStatuses.approved:
        {
          text = 'Approved'.tr;
          break;
        }
      case OrderStatuses.returnedToLocation:
        {
          text = 'Rturned to location'.tr;
          break;
        }
      // case OrderStatuses.inTransit:
      //   {
      //     text = 'In Transt'.tr;
      //     break;
      //   }

      default:
        {
          text = 'New Status';
          break;
        }
    }

    return text;
  }

  static Widget chooseStatusButtons(
      {required String inputText,
      required bool isNotAssigned,
      required bool hasParentOrderId}) {
    switch (inputText) {
      case OrderStatuses.returnedToDeliveryCenter:
        {
          return OutForDeleveryFromReturnButtons();
        }
      // new cases

      // case OrderStatuses.approved:
      //   {
      //     return InTransitButtons();
      //   }

      // case OrderStatuses.inTransit:
      //   {
      //     return ReturnButtons();
      //   }

      ////////////////////////

      case OrderStatuses.inDeliveryCenter:
        {
          if (hasParentOrderId) {
            return SizedBox();
          } else {
            return InDeliveryCenterButtons();
          }
        }

      case OrderStatuses.outForDelivery:
        {
          if (hasParentOrderId) {
            return InDeliveryCenterFromReturnButtons();
          } else {
            return OutForDeliveryButtons();
          }
        }
      case OrderStatuses.delivered:
        {
          if (isNotAssigned) {
            return InDeliveryCenterButtons();
          } else {
            if (hasParentOrderId) {
              return OutForReturnButtons();
            } else {
              // return DeliveredButtons();
              return const SizedBox.shrink();
            }
          }
        }

      case OrderStatuses.partialReturn:
        {
          return PartialReturnButtons();
        }

      case OrderStatuses.returned:
        {
          return ReturnButtons();
        }

      case OrderStatuses.failed:
        {
          return FailedButtons();
        }

      case OrderStatuses.canceled:
        {
          return CanceledButtons();
        }

      case OrderStatuses.canceledArchived:
        {
          return CanceledArchivedButtons();
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

  static Future<void> setLocalStorageData<T extends JsonSerializable>({
    required T infoData,
    required T Function(Map<String, dynamic>)? fromJson,
    required String key,
    int maxNumberOfData = 40,
  }) async {
    List<T> data = getLocalStorageData(fromJson: fromJson!, key: key);

    if (data.length >= maxNumberOfData) {
      data.removeAt(data.length - 1);
      data.insert(0, infoData);
    } else {
      data.insert(0, infoData);
    }

    var infoListToJson = data.map((e) => e.toJson()).toList();

    String encodedData = json.encode(infoListToJson);

    await prefs.setString(key, encodedData);
  }

  static List<T> getLocalStorageData<T extends JsonSerializable>({
    required T Function(Map<String, dynamic>)? fromJson,
    required String key,
  }) {
    final data = prefs.getString(key);

    if (data != null) {
      final decodedData = json.decode(data);
      List<T> infoListFromJson =
          List<T>.from(decodedData.map((e) => fromJson!(e)));

      return infoListFromJson;
    } else {
      return [];
    }
  }

  static Future<void> deleteLocalStorageData<T extends JsonSerializable>({
    required int index,
    required T Function(Map<String, dynamic>) fromJson,
    required String key,
  }) async {
    List<T> data = getLocalStorageData(fromJson: fromJson, key: key);

    data.removeAt(index);

    var infoListToJson = data.map((e) => e.toJson()).toList();

    String encodedData = json.encode(infoListToJson);

    await prefs.setString(key, encodedData);
  }

  static Future<void> updateLocalStorageData<T extends JsonSerializable>({
    required int index,
    required T updatedData,
    required T Function(Map<String, dynamic>) fromJson,
    required String key,
  }) async {
    List<T> data = getLocalStorageData(fromJson: fromJson, key: key);

    data[index] = updatedData;

    var infoListToJson = data.map((e) => e.toJson()).toList();

    String encodedData = json.encode(infoListToJson);

    await prefs.setString(key, encodedData);
  }

  static Future<void> deleteAllLocalStorageData({
    required String key,
  }) async {
    await prefs.remove(key);
  }
}
