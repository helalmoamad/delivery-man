import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/get_my_orders_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/get_order_status_data.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/handling_errors.dart/handling_errors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrdersController extends GetxController {
  bool isGetMyOrdersNoInternetConnection = false;
  bool isGetMyOrdersCircleShown = false;

  bool isGetOrderStatusCircleShown = false;
  bool isGetOrderStatusNoInternetConnection = false;

  late ListOrderModel myOrdersData;
  late GetMyOrdersProvider getMyOrdersProvider =
      Get.find<GetMyOrdersProvider>();

  late List<dynamic> orderStatusData;
  GetOrderStatusDataProvider getOrderStatusDataProvider =
      Get.find<GetOrderStatusDataProvider>();

  late String orderStatus;
  int selectedOrderStatus = 0;

  int orderIndex = 0;

  late ScrollController scrollController;
  int paginationOffset = 2;
  bool noMoreItems = false;

  @override
  void onInit() async {
    super.onInit();
    debugPrint('Order Controller Init');
    scrollController = ScrollController();
    String token = GlobalFunctions.getFcmToken();
    await getOrderStatusData(
      token: token,
    );

    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        debugPrint('scrollController');
        await getMyOrdersWithPaginationData(token: token, status: orderStatus);
      }
    });
  }

  @override
  void onClose() async {
    super.onClose();
    scrollController.dispose();

    debugPrint('Order Controller closed');
  }

  Future<void> chooseOrderStatus(
      {required String status, required int index}) async {
    String token = GlobalFunctions.getFcmToken();
    orderStatus = status;
    if (index != selectedOrderStatus) {
      selectedOrderStatus = index;
      await getMyOrdersData(token: token, status: orderStatus, offset: 1);
    }

    update();
  }

  // ///////////////////////////
  void showGetMyOrdersCircleIndicator() {
    isGetMyOrdersCircleShown = true;
    update();
  }

  void hideGetMyOrdersCircleIndicator() {
    isGetMyOrdersCircleShown = false;
    update();
  }

  void showGetMyOrdersNoInternetPage() {
    isGetMyOrdersNoInternetConnection = true;
    update();
  }

  void hideGetMyOrdersNoInternetPage() {
    isGetMyOrdersNoInternetConnection = false;
    update();
  }

  // ///////////////////////////
  void showGetOrderStatusCircleIndicator() {
    isGetOrderStatusCircleShown = true;
    update();
  }

  void hideGetOrderStatusCircleIndicator() {
    isGetOrderStatusCircleShown = false;
    update();
  }

  ///////////////////////////////////
  void showGetOrderStatusNoInternetPage() {
    isGetOrderStatusNoInternetConnection = true;
    update();
  }

  void hideGetOrderStatusNoInternetPage() {
    isGetOrderStatusNoInternetConnection = false;
    update();
  }

  ///////////////////////////////////
  Future<void> getOrderStatusData({required String token}) async {
    showGetOrderStatusCircleIndicator();
    final failureOrGetOrderStatusData =
        await getOrderStatusDataProvider.call(token: token);
    failureOrGetOrderStatusData.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideGetOrderStatusCircleIndicator,
          showNoInternetPage: showGetOrderStatusNoInternetPage);
    }, (getOrderStatusData) async {
      orderStatusData = getOrderStatusData;
      orderStatus = orderStatusData[0].toString();
      selectedOrderStatus = 0;
      hideGetOrderStatusCircleIndicator();
      hideGetOrderStatusNoInternetPage();
      await getMyOrdersData(token: token, status: orderStatus, offset: 1);
    });
  }

  ///////////////////////////////////
  Future<void> getMyOrdersData({
    required String token,
    required String status,
    required int offset,
  }) async {
    showGetMyOrdersCircleIndicator();
    paginationOffset = 2;
    noMoreItems = false;
    final failureOrGetOrdersData = await getMyOrdersProvider.call(
        token: token, status: status, offset: offset);
    failureOrGetOrdersData.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideGetMyOrdersCircleIndicator,
          showNoInternetPage: showGetMyOrdersNoInternetPage);
    }, (getOrdersData) {
      myOrdersData = getOrdersData;
      hideGetMyOrdersCircleIndicator();
      hideGetMyOrdersNoInternetPage();
    });
  }

// ///////////////////////////////////
  Future<void> getMyOrdersWithPaginationData({
    required String token,
    required String status,
  }) async {
    if (noMoreItems) {
      debugPrint('No More Items');
    } else {
      final failureOrGetOrdersData = await getMyOrdersProvider.call(
          token: token, status: status, offset: paginationOffset);
      failureOrGetOrdersData.fold((failure) {
        HandlingErrors.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: () {},
            showNoInternetPage: () {});
      }, (getOrdersData) {
        if (getOrdersData.data!.data!.isEmpty) {
          noMoreItems = true;
          debugPrint('No More Items');
        } else {
          paginationOffset++;
          myOrdersData.data!.total = getOrdersData.data!.total;
          myOrdersData.data!.data!.addAll(getOrdersData.data!.data!);
        }
        update();
      });
    }
  }
}
