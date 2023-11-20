import 'package:audioplayers/audioplayers.dart';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/models/Orders/change_status_model.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/assign_order_tome_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/change_order_status.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/get_my_orders_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/unassign_to_vehicle_provider.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../models/Orders/list_order_model.dart';
import '../../providers/Orders_providers.dart/get_order_list_provider.dart';
import '../../providers/Orders_providers.dart/get_order_status_data.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/snackbar_widgets.dart';
import 'package:path/path.dart' as p;

class OrdersController extends GetxController {
  bool isGetOrdersNoInternetConnection = false;
  bool isGetOrdersCircleShown = false;

  bool isGetOrderStatusCircleShown = false;
  bool isGetOrderStatusNoInternetConnection = false;

  bool isAnAssignedCircleShown = false;

  bool isAssignOrderCircleShown = false;

  bool isChangeOrderStatusCircleShown = false;

  String previousRoute = '';

  late ListOrderModel ordersData;
  late List<dynamic> orderStatusData;

  late UnAssignToVehicleProvider unAssignToVehicleProvider =
      Get.find<UnAssignToVehicleProvider>();
  late UnAssignToVehicleModel unAssignToVehicleData;

  late AssignOrderToMeProvider assignOrderToMeProvider =
      Get.find<AssignOrderToMeProvider>();
  late AssignOrderToMeDataModel assignOrderToMeData;

  late ChangeOrderStatusProvider changeOrderStatusProvider =
      Get.find<ChangeOrderStatusProvider>();
  late ChangeStatusModle changeStatusData;

  int orderIndex = 0;

  late String orderStatus;
  int selectedOrderStatus = 0;

  GetListOrderDataProvider getListOrderDataProvider =
      Get.find<GetListOrderDataProvider>();

  GetOrderStatusDataProvider getOrderStatusDataProvider =
      Get.find<GetOrderStatusDataProvider>();

  late ScrollController orderScrollController;
  int orderPaginationOffset = 2;
  bool orderNoMoreItems = false;

  late Record record;
  late AudioPlayer audioPlayer;

  bool isRecording = false;
  bool isRecordPlaying = false;
  String? audioPath = '';

  bool isStartDeliveryButton = true;

  bool isGetMyOrdersNoInternetConnection = false;
  bool isGetMyOrdersCircleShown = false;

  bool isGetMyOrderStatusCircleShown = false;
  bool isGetMyOrderStatusNoInternetConnection = false;

  late ListOrderModel myOrdersData;
  late GetMyOrdersProvider getMyOrdersProvider =
      Get.find<GetMyOrdersProvider>();

  late String myOrderStatus;
  int selectedMyOrderStatus = 0;

  int myOrderIndex = 0;

  late ScrollController myOrderScrollController;
  int myOrderPaginationOffset = 2;
  bool myOrderNoMoreItems = false;

  List<ProductModel> returnedProductsList = [];

  int moreDeveloperInfoIndex = 0;

  late ItemScrollController myOrderStatusScrollController;

  @override
  void onInit() async {
    super.onInit();
    debugPrint('Order Controller Init');
    String token = GlobalFunctions.getFcmToken();
    if (Get.currentRoute == Routes.orderssPage) {
      orderScrollController = ScrollController();
      await getOrderStatusData(token: token, isForAllOrders: true);
      orderScrollController.addListener(() async {
        if (orderScrollController.position.maxScrollExtent ==
            orderScrollController.offset) {
          debugPrint('scrollController');
          await getListOrderWithPaginationData(
              token: token, status: orderStatus);
        }
      });
    }

    if (Get.currentRoute == Routes.myOrdersPage) {
      myOrderScrollController = ScrollController();
      myOrderStatusScrollController = ItemScrollController();
      await getOrderStatusData(token: token, isForAllOrders: false);
      myOrderScrollController.addListener(() async {
        if (myOrderScrollController.position.maxScrollExtent ==
            myOrderScrollController.offset) {
          debugPrint('scrollController');
          await getMyOrdersWithPaginationData(
              token: token, status: myOrderStatus);
        }
      });

      record = Record();
      audioPlayer = AudioPlayer();
    }
  }

  @override
  void onClose() async {
    super.onClose();

    debugPrint('Order Controller closed');
  }

  Future<void> removeRequestFromDeveloperInfo(int index) async {
    await GlobalFunctions.deleteRequestInfo(index: index);
    update();
  }

  Future<void> removeAllRequestsInfo() async {
    await GlobalFunctions.deleteAllRequestsInfo();
    update();
  }

  void addReturnedProducts(ProductModel orderProduct) {
    if (returnedProductsList.isEmpty) {
      debugPrint('isEmpty');
      returnedProductsList.add(orderProduct);
    } else {
      bool isValueInList =
          returnedProductsList.any((element) => element.id == orderProduct.id);

      if (isValueInList == false) {
        returnedProductsList.add(orderProduct);
        debugPrint('Value not In List');
      } else {
        debugPrint('Value In List');
        returnedProductsList
            .removeWhere((element) => element.id == orderProduct.id);
      }
    }
    update();
  }

  bool isProductInReturnedProducts(ProductModel orderProduct) {
    if (returnedProductsList.isEmpty) {
      return false;
    } else {
      bool isValueInList =
          returnedProductsList.any((element) => element.id == orderProduct.id);

      return isValueInList;
    }
  }

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
    isAssignOrderCircleShown = true;
    update();
  }

  void hideAssignOrderCircleIndicator() {
    isAssignOrderCircleShown = false;
    update();
  }

  // ///////////////////////////
  void showChangeOrderStatusCircleIndicator() {
    isChangeOrderStatusCircleShown = true;
    update();
  }

  void hideChangeOrderStatusCircleIndicator() {
    isChangeOrderStatusCircleShown = false;
    update();
  }

  void changeDeliveringButton(bool isStartDelivery) {
    isStartDeliveryButton = isStartDelivery;
    update();
  }

  void changeIsPlaying(bool isPlaying) {
    isRecordPlaying = isPlaying;
    update();
  }

  /////// MyOrders
  Future<void> chooseMyOrderStatus(
      {required String status, required int index}) async {
    String token = GlobalFunctions.getFcmToken();
    myOrderStatus = status;
    if (index != selectedMyOrderStatus) {
      selectedMyOrderStatus = index;

      myOrderStatusScrollController.jumpTo(index: index);

      await getMyOrdersData(token: token, status: myOrderStatus, offset: 1);
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
  void showGetMyOrderStatusCircleIndicator() {
    isGetMyOrderStatusCircleShown = true;
    update();
  }

  void hideGetMyOrderStatusCircleIndicator() {
    isGetMyOrderStatusCircleShown = false;
    update();
  }

  ///////////////////////////////////
  void showGetMyOrderStatusNoInternetPage() {
    isGetMyOrderStatusNoInternetConnection = true;
    update();
  }

  void hideGetMyOrderStatusNoInternetPage() {
    isGetMyOrderStatusNoInternetConnection = false;
    update();
  }
  //////////////////////////////////////////////////

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

  Future<void> startRecording({required String orderId}) async {
    try {
      if (await record.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final filepath = p.join(
          dir.path,
          'audio_${orderId}_${DateTime.now()}.m4a',
        );
        await record.start(path: filepath);
        isRecording = true;
        changeDeliveringButton(false);
        update();
      } else {
        SnackBarWidgets.showFailureSnackBar(
            '', 'You need voice recording permission'.tr);
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
    orderPaginationOffset = 2;
    orderNoMoreItems = false;
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
    if (orderNoMoreItems) {
      debugPrint('No More Items');
    } else {
      final failureOrGetOrdersData = await getListOrderDataProvider.call(
          token: token, status: status, offset: orderPaginationOffset);
      failureOrGetOrdersData.fold((failure) {
        HandlingErrors.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: () {},
            showNoInternetPage: () {});
      }, (getOrdersData) {
        if (getOrdersData.data!.data!.isEmpty) {
          orderNoMoreItems = true;
          debugPrint('No More Items');
        } else {
          orderPaginationOffset++;
          ordersData.data!.total = getOrdersData.data!.total;
          ordersData.data!.data!.addAll(getOrdersData.data!.data!);
        }
        update();
      });
    }
  }

  ///////////////////////////////////
  Future<void> getOrderStatusData({
    required String token,
    required bool isForAllOrders,
  }) async {
    isForAllOrders
        ? showGetOrderStatusCircleIndicator()
        : showGetMyOrderStatusCircleIndicator();

    final failureOrGetOrderStatusData =
        await getOrderStatusDataProvider.call(token: token);
    failureOrGetOrderStatusData.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: isForAllOrders
              ? hideGetOrderStatusCircleIndicator
              : hideGetMyOrderStatusCircleIndicator,
          showNoInternetPage: isForAllOrders
              ? showGetOrderStatusNoInternetPage
              : showGetMyOrderStatusNoInternetPage);
    }, (getOrderStatusData) async {
      orderStatusData = getOrderStatusData;
      if (isForAllOrders) {
        orderStatus = orderStatusData[0].toString();
        selectedOrderStatus = 0;
      } else {
        ////
        myOrderStatus = orderStatusData[2].toString();
        selectedMyOrderStatus = 0;
      }

      ///
      isForAllOrders
          ? hideGetOrderStatusCircleIndicator()
          : hideGetMyOrderStatusCircleIndicator();
      isForAllOrders
          ? hideGetOrderStatusNoInternetPage()
          : hideGetMyOrderStatusNoInternetPage();
      isForAllOrders
          ? await getListOrderData(token: token, status: orderStatus, offset: 1)
          : await getMyOrdersData(
              token: token, status: myOrderStatus, offset: 1);
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
      await GlobalFunctions.setAssignVehicleToUserId(
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
      Get.close(1);
      Get.offAllNamed(Routes.myOrdersPage);
      // await getListOrderData(token: token, status: orderStatus, offset: 1);
    });
  }

  Future<void> changeOrderStatus({
    required String token,
    required String status,
    required int orderId,
    int? amount,
    List<ProductModel>? returnedProducts,
    String? file,
  }) async {
    showChangeOrderStatusCircleIndicator();
    final failureOrData = await changeOrderStatusProvider.call(
        token: token,
        orderId: orderId,
        file: file,
        status: status,
        returnedProducts: returnedProducts,
        amount: amount);

    failureOrData.fold((failure) {
      HandlingErrors.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideChangeOrderStatusCircleIndicator,
          showNoInternetPage: () {});
    }, (data) async {
      // changeStatusData = data;
      hideChangeOrderStatusCircleIndicator();
      SnackBarWidgets.showSuccessSnackBar(
          'Changing Order Status Succeeded'.tr, '');
      Get.close(1);

      if (status == 'delivered' ||
          status == 'partial_return' ||
          status == 'returned' ||
          status == 'failed') {
        changeDeliveringButton(true);
        audioPath = '';
      }

      if (status == 'partial_return') {
        await chooseMyOrderStatus(
            status: status, index: selectedMyOrderStatus + 2);
      } else if (status == 'returned') {
        await chooseMyOrderStatus(
            status: status, index: selectedMyOrderStatus + 3);
      } else if (status == 'failed') {
        await chooseMyOrderStatus(
            status: status, index: selectedMyOrderStatus + 4);
      } else {
        await chooseMyOrderStatus(
            status: status, index: selectedMyOrderStatus + 1);
      }
    });
  }

  //// MyOrders /////////////////////
  ///////////////////////////////////
  Future<void> getMyOrdersData({
    required String token,
    required String status,
    required int offset,
  }) async {
    showGetMyOrdersCircleIndicator();
    myOrderPaginationOffset = 2;
    myOrderNoMoreItems = false;
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
    if (myOrderNoMoreItems) {
      debugPrint('No More Items');
    } else {
      final failureOrGetOrdersData = await getMyOrdersProvider.call(
          token: token, status: status, offset: myOrderPaginationOffset);
      failureOrGetOrdersData.fold((failure) {
        HandlingErrors.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: () {},
            showNoInternetPage: () {});
      }, (getOrdersData) {
        if (getOrdersData.data!.data!.isEmpty) {
          myOrderNoMoreItems = true;
          debugPrint('No More Items');
        } else {
          myOrderPaginationOffset++;
          myOrdersData.data!.total = getOrdersData.data!.total;
          myOrdersData.data!.data!.addAll(getOrdersData.data!.data!);
        }
        update();
      });
    }
  }
}
