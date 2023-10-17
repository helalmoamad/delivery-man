import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/Orders/list_order_model.dart';
import '../../providers/Orders_providers.dart/get_order_list_provider.dart';
import '../../providers/Orders_providers.dart/get_order_status_data.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';

class OrdersController extends GetxController {
  bool isGetOrdersNoInternetConnection = false;
  bool isGetOrdersCircleShown = false;

  bool isGetOrderStatusCircleShown = false;
  bool isGetOrderStatusNoInternetConnection = false;

  late ListOrderModel ordersData;
  late List<dynamic> orderStatusData;

  late String orderStatus;
  int selectedOrderStatus = 0;

  GetListOrderDataProvider getListOrderDataProvider =
      Get.find<GetListOrderDataProvider>();

  GetOrderStatusDataProvider getOrderStatusDataProvider =
      Get.find<GetOrderStatusDataProvider>();

  final ScrollController scrollController = ScrollController();
  int paginationOffset = 2;
  bool noMoreItems = false;

  // ///////////////////////////
  void showGetOrdersCircleIndicator() {
    isGetOrdersCircleShown = true;
    update();
  }

  void hideGetOrdersCircleIndicator() {
    isGetOrdersCircleShown = false;
    update();
  }

///////////////////////////////////
  void showGetOrdersNoInternetPage() {
    isGetOrdersNoInternetConnection = true;
    update();
  }

  void hideGetOrdersNoInternetPage() {
    isGetOrdersNoInternetConnection = false;
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

  @override
  void onInit() async {
    super.onInit();
    debugPrint('Order Controller Init');
    String token = GlobalFunctions.getFcmToken();
    await getOrderStatusData(token: token);

    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        debugPrint('scrollController');
        await getListOrderWithPaginationData(token: token, status: orderStatus);
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
      await getListOrderData(token: token, status: orderStatus, offset: 1);
    }

    update();
  }

  ///////////////////////////////////
  Future<void> getListOrderData({
    required String token,
    required String status,
    required int offset,
  }) async {
    showGetOrdersCircleIndicator();
    paginationOffset = 2;
    noMoreItems = false;
    final failureOrGetOrdersData = await getListOrderDataProvider.call(
        token: token, status: status, offset: offset);
    failureOrGetOrdersData.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideGetOrdersCircleIndicator,
          showNoInternetPage: showGetOrdersNoInternetPage);
    }, (getOrdersData) {
      ordersData = getOrdersData;
      hideGetOrdersCircleIndicator();
      hideGetOrdersNoInternetPage();
    });
  }

///////////////////////////////////
  Future<void> getListOrderWithPaginationData({
    required String token,
    required String status,
  }) async {
    if (noMoreItems) {
      debugPrint('No More Items');
    } else {
      final failureOrGetOrdersData = await getListOrderDataProvider.call(
          token: token, status: status, offset: paginationOffset);
      failureOrGetOrdersData.fold((failure) {
        HandlingErrors.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: () {},
            showNoInternetPage: () {});
      }, (getOrdersData) {
        if (getOrdersData.data!.orders!.isEmpty) {
          noMoreItems = true;
          debugPrint('No More Items');
        } else {
          paginationOffset++;
          ordersData.data!.total = getOrdersData.data!.total;
          ordersData.data!.limit = getOrdersData.data!.limit;
          ordersData.data!.offset = getOrdersData.data!.offset;
          ordersData.data!.orders!.addAll(getOrdersData.data!.orders!);
        }
        update();
      });
    }
  }

  ///////////////////////////////////
  Future<void> getOrderStatusData({
    required String token,
  }) async {
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
      hideGetOrderStatusCircleIndicator();
      hideGetOrderStatusNoInternetPage();
      await getListOrderData(token: token, status: orderStatus, offset: 1);
    });
  }
}
