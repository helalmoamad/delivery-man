import 'package:audioplayers/audioplayers.dart';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/assign_order_tome_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/unassign_to_vehicle_provider.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import '../../models/Orders/list_order_model.dart';
import '../../providers/Orders_providers.dart/get_order_list_provider.dart';
import '../../providers/Orders_providers.dart/get_order_status_data.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/snackbar_widgets.dart';

class OrdersController extends GetxController {
  bool isGetOrdersNoInternetConnection = false;
  bool isGetOrdersCircleShown = false;

  bool isGetOrderStatusCircleShown = false;
  bool isGetOrderStatusNoInternetConnection = false;

  bool isAnAssignedCircleShown = false;

  bool isAssigneOrderCircleShown = false;

  late ListOrderModel ordersData;
  late List<dynamic> orderStatusData;

  late UnAssignToVehicleProvider unAssignToVehicleProvider = Get.find();
  late UnAssignToVehicleModel unAssignToVehicleData;

  late AssignOrderToMeProvider assignOrderToMeProvider = Get.find();
  late AssignOrderToMeDataModel assignOrderToMeData;

  int orderIndex = 0;

  late String orderStatus;
  int selectedOrderStatus = 0;

  GetListOrderDataProvider getListOrderDataProvider =
      Get.find<GetListOrderDataProvider>();

  GetOrderStatusDataProvider getOrderStatusDataProvider =
      Get.find<GetOrderStatusDataProvider>();

  late ScrollController scrollController;
  int paginationOffset = 2;
  bool noMoreItems = false;

  late Record record;
  late AudioPlayer audioPlayer;
  bool isStartDeliveryButton = true;
  bool isPlayRecordButton = false;
  bool isRecording = false;
  bool isRecordPlaying = false;
  String? audioPath = '';

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

///////////////////////////////////

  // ///////////////////////////
  void showUnAssignedCircleIndicator() {
    isAnAssignedCircleShown = true;
    update();
  }

  void hideUnAssignedCircleIndicator() {
    isAnAssignedCircleShown = false;
    update();
  }

  // ///////////////////////////
  void showAssignOrderCircleIndicator() {
    isAssigneOrderCircleShown = true;
    update();
  }

  void hideAssignOrderCircleIndicator() {
    isAssigneOrderCircleShown = false;
    update();
  }

  void changeDeliveringButton(bool isStartDelivery) {
    isStartDeliveryButton = isStartDelivery;
    update();
  }

  void changePlayRecordButton(bool isPlayRecord) {
    isPlayRecordButton = isPlayRecord;
    update();
  }

  void changeIsPlaying(bool isPlaying) {
    isRecordPlaying = isPlaying;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    debugPrint('Order Controller Init');
    scrollController = ScrollController();
    String token = GlobalFunctions.getFcmToken();
    await getOrderStatusData(token: token, isForAllOrders: true);

    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        debugPrint('scrollController');
        await getListOrderWithPaginationData(token: token, status: orderStatus);
      }
    });

    record = Record();
    audioPlayer = AudioPlayer();
  }

  @override
  void onClose() async {
    super.onClose();
    scrollController.dispose();
    record.dispose();
    audioPlayer.dispose();

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

  Future<void> startRecording() async {
    try {
      if (await record.hasPermission()) {
        await record.start();
        isRecording = true;
        update();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      if (await record.hasPermission()) {
        audioPath = await record.stop();
        isRecording = false;
        update();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath!);
      await audioPlayer.play(urlSource);

      audioPlayer.onPlayerComplete.listen((event) {
        changeIsPlaying(false);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopPlayingRecording() async {
    try {
      await audioPlayer.stop();
    } catch (e) {
      debugPrint(e.toString());
    }
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
  Future<void> getOrderStatusData(
      {required String token, required bool isForAllOrders}) async {
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
      isForAllOrders
          ? await getListOrderData(token: token, status: orderStatus, offset: 1)
          : null;
    });
  }

  Future<void> unAssignToVehicle(
      {required String token, required int vehicleId}) async {
    showUnAssignedCircleIndicator();
    final failureOrAssignToVehicle = await unAssignToVehicleProvider.call(
        token: token, vehicleId: vehicleId);

    failureOrAssignToVehicle.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideUnAssignedCircleIndicator,
          showNoInternetPage: () {});
    }, (getUnAssignToVehicleData) async {
      unAssignToVehicleData = getUnAssignToVehicleData;
      hideUnAssignedCircleIndicator();
      SnackBarWidgets.showSuccessSnackBar(
          'UnAssign To Vehicle Succeeded'.tr, '');
      await GlobalFunctions.setAssignToUserId(
          assignToUserId: unAssignToVehicleData.data!.assignToUserId);
      update();
    });
  }

  Future<void> assignOrderToMe(
      {required String token, required int orderId}) async {
    showAssignOrderCircleIndicator();
    final failureOrAssignToVehicle =
        await assignOrderToMeProvider.call(token: token, orderId: orderId);

    failureOrAssignToVehicle.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideAssignOrderCircleIndicator,
          showNoInternetPage: () {});
    }, (data) async {
      assignOrderToMeData = data;
      hideAssignOrderCircleIndicator();
      SnackBarWidgets.showSuccessSnackBar('Assign Order Succeeded'.tr, '');
      // await GlobalFunctions.setAssignToUserId(
      //     assignToUserId: unAssignToVehicleData.data!.assignToUserId);
      update();
    });
  }
}
