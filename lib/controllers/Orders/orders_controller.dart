import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delivery_man_app/background_service/background_service.dart';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/models/Orders/change_status_model.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/assign_order_tome_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/change_order_received_amount_provider.dart';
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
import '../../models/Orders/unassign_order_tome_model.dart';
import '../../models/Orders/upload_voice_model.dart';
import '../../providers/Orders_providers.dart/get_details_provider.dart';
import '../../providers/Orders_providers.dart/get_order_list_provider.dart';
import '../../providers/Orders_providers.dart/get_order_status_data.dart';
import '../../providers/Orders_providers.dart/unassign_order_tome_provider.dart';
import '../../shared/constants/failure_messages.dart';
import '../../shared/constants/notifications_types.dart';
import '../../shared/constants/order_statuses.dart';
import '../../shared/constants/success_messages.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/network_info/network_info.dart';
import '../../shared/widgets/snackbar_widgets.dart';
import 'package:path/path.dart' as p;

import '../Client/client_controller.dart';
import '../Client/timer_service.dart';

class OrdersController extends GetxController {
  bool isGetOrdersNoInternetConnection = false;
  bool isGetOrdersCircleShown = false;

  bool isGetOrderStatusCircleShown = false;
  bool isGetOrderStatusNoInternetConnection = false;

  bool isAnAssignedCircleShown = false;

  bool isAssignUnAssignOrderCircleShown = false;

  bool isChangeOrderStatusCircleShown = false;

  bool isMyOrderPage = false;

  String previousRoute = '';

  ListOrderModel? ordersData;
  late List<dynamic> orderStatusData;

  late UnAssignToVehicleProvider unAssignToVehicleProvider =
      Get.find<UnAssignToVehicleProvider>();
  late UnAssignToVehicleModel unAssignToVehicleData;

  late AssignOrderToMeProvider assignOrderToMeProvider =
      Get.find<AssignOrderToMeProvider>();
  late AssignOrderToMeDataModel assignOrderToMeData;

  late ChangeOrderStatusProvider changeOrderStatusProvider =
      Get.find<ChangeOrderStatusProvider>();
  late ChangeStatusModel changeStatusData;

  late ChangeOrderReceivedAmountProvider changeOrderReceivedAmountProvider =
      Get.find<ChangeOrderReceivedAmountProvider>();

  late GetOrderDetailsProvider getOrderDetailsProvider =
      Get.find<GetOrderDetailsProvider>();

  late UnAssignOrderToMeProvider unAssignOrderToMeProvider =
      Get.find<UnAssignOrderToMeProvider>();

  int orderIdForDetails = 0;
  int myOrderIdForDetails = 0;

  String orderStatus = '';
  int selectedOrderStatus = 0;

  GetListOrderDataProvider getListOrderDataProvider =
      Get.find<GetListOrderDataProvider>();

  GetOrderStatusDataProvider getOrderStatusDataProvider =
      Get.find<GetOrderStatusDataProvider>();

  late ScrollController orderScrollController;
  int orderPaginationOffset = 2;
  bool orderNoMoreItems = false;

  AudioRecorder? record;
  AudioPlayer? audioPlayer;

  bool isRecording = false;
  bool isRecordPlaying = false;
  String? audioPath = '';

  bool isStartDeliveryButton = true;

  bool isGetMyOrdersNoInternetConnection = false;
  bool isGetMyOrdersCircleShown = false;

  bool isGetMyOrderStatusCircleShown = false;
  bool isGetMyOrderStatusNoInternetConnection = false;

  ListOrderModel? myOrdersData;
  late GetMyOrdersProvider getMyOrdersProvider =
      Get.find<GetMyOrdersProvider>();

  String myOrderStatus = '';
  int selectedMyOrderStatus = 0;

  late ScrollController myOrderScrollController;
  int myOrderPaginationOffset = 2;
  bool myOrderNoMoreItems = false;

  List<ProductModel> returnedProductsList = [];

  late ItemScrollController myOrderStatusScrollController;

  final HttpClientService httpClientController = Get.find<HttpClientService>();
  final TimerService timerService = Get.find<TimerService>();

  final NetworkInfo networkInfo = Get.find<NetworkInfo>();

  bool isNoConnectionMessageShown = false;
  bool isBackConnectionMessageShown = true;
  final Connectivity connectivity = Get.find<Connectivity>();

  Future<void> autoCheckConnection() async {
    connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      debugPrint(result.toString());
      ////////////////////////////////////////////
      if (!await networkInfo.isConnected) {
        if (!isNoConnectionMessageShown) {
          SnackBarWidgets.showFailureSnackBar(
            'No Connection'.tr,
            AppFailureMessages.offlineFailureMessage,
          );
          isNoConnectionMessageShown = true;
          isBackConnectionMessageShown = false;
        }
      } else {
        if (!isBackConnectionMessageShown) {
          SnackBarWidgets.showSuccessSnackBar(
              AppSuccessMessages.connectionBackSucceededMessage, '');
          isBackConnectionMessageShown = true;
          isNoConnectionMessageShown = false;
          ///////////////////////////
          List<UploadVoiceModel> data = GlobalFunctions.getLocalStorageData(
            fromJson: UploadVoiceModel.fromJson,
            key: 'upload_voice',
          );
          if (data.isNotEmpty) {
            startUploadFileService();
          }
        }
      }
    });
    //////////////////////////
    if (!await networkInfo.isConnected) {
      if (!isNoConnectionMessageShown) {
        SnackBarWidgets.showFailureSnackBar(
          'No Connection'.tr,
          AppFailureMessages.offlineFailureMessage,
        );
        isNoConnectionMessageShown = true;
        isBackConnectionMessageShown = false;
      }
    }
  }

  void onNotifiNavigation() async {
    if (GlobalFunctions.getNotifiType() == NotificationsTypes.newOrder ||
        GlobalFunctions.getNotifiType() ==
            NotificationsTypes.orderRequiresAssingment ||
        GlobalFunctions.getNotifiType() ==
            NotificationsTypes.orderRequiresShipping) {
      await const Duration(milliseconds: 100).delay();
      debugPrint('//// Navigate to orderDetails page////');
      await GlobalFunctions.setIsFromNotifiForNewOrder(
          isFromNotifiForNewOrder: true);
      await GlobalFunctions.setNotifiType(notifiType: '');
      /////////////////////////////////////
      Get.toNamed(Routes.ordersDetailsPage);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    debugPrint('Order Controller Init');
    String token = GlobalFunctions.getToken();
    if (Get.currentRoute == Routes.orderssPage) {
      isMyOrderPage = false;
      orderScrollController = ScrollController();
      if (Get.previousRoute == Routes.myOrdersPage) {
        httpClientController.closeSecondaryClient();
        timerService.stopTimer(isGlobalTimer: false);
      }
      // await getOrderStatusData(token: token, isForAllOrders: true);
      orderStatus = OrderStatuses.inDeliveryCenter;
      await getListOrderData(token: token, status: orderStatus, offset: 1);
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
      isMyOrderPage = true;
      myOrderScrollController = ScrollController();
      myOrderStatusScrollController = ItemScrollController();
      if (Get.previousRoute == Routes.orderssPage) {
        httpClientController.closeSecondaryClient();
        timerService.stopTimer(isGlobalTimer: false);
      }
      await getOrderStatusData(token: token, isForAllOrders: false);
      myOrderScrollController.addListener(() async {
        if (myOrderScrollController.position.maxScrollExtent ==
            myOrderScrollController.offset) {
          debugPrint('scrollController');
          await getMyOrdersWithPaginationData(
              token: token, status: myOrderStatus);
        }
      });

      record = AudioRecorder();
      audioPlayer = AudioPlayer();
    }

    onNotifiNavigation();
    ///////////////////
    autoCheckConnection();
    ////////////////////
  }

  @override
  void onClose() async {
    super.onClose();

    debugPrint('Order Controller closed');
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
  void showAssignUnAssignOrderCircleIndicator() {
    isAssignUnAssignOrderCircleShown = true;
    update(['change_status']);
  }

  void hideAssignUnAssignOrderCircleIndicator() {
    isAssignUnAssignOrderCircleShown = false;
    update(['change_status']);
  }

  // ///////////////////////////
  void showChangeOrderStatusCircleIndicator() {
    isChangeOrderStatusCircleShown = true;
    update(['change_status']);
  }

  void hideChangeOrderStatusCircleIndicator() {
    isChangeOrderStatusCircleShown = false;
    update(['change_status']);
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
  Future<void> chooseMyOrderStatus({
    required String status,
    required int index,
    bool isForAssignToMe = false,
  }) async {
    String token = GlobalFunctions.getToken();
    myOrderStatus = status;
    if (index != selectedMyOrderStatus) {
      selectedMyOrderStatus = index;

      isForAssignToMe
          ? null
          : myOrderStatusScrollController.jumpTo(index: index);

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

  Future<void> chooseOrderStatus({
    required String status,
    required int index,
  }) async {
    String token = GlobalFunctions.getToken();
    orderStatus = status;
    if (index != selectedOrderStatus) {
      selectedOrderStatus = index;
      await getListOrderData(token: token, status: orderStatus, offset: 1);
    }

    update();
  }

  Future<void> startRecording({required String orderId}) async {
    try {
      if (await record!.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final filepath = p.join(
          dir.path,
          'audio_${orderId}_millisecond_date_${DateTime.now().millisecond}.m4a',
        );
        await record!.start(const RecordConfig(), path: filepath);
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
      if (await record!.hasPermission()) {
        audioPath = await record!.stop();
        isRecording = false;
        update();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteRecording({required String filePath}) async {
    final file = File(filePath);
    try {
      if (await file.exists()) {
        await file.delete();
        debugPrint('File deleted: $filePath');
      }
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath!);
      await audioPlayer!.play(urlSource);

      audioPlayer!.onPlayerComplete.listen((event) {
        changeIsPlaying(false);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> stopPlayingRecording() async {
    try {
      await audioPlayer!.stop();
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
      HandlingFailures.networkErrorrHandling(
        failure: failure,
        hideCircleIndicator: hideGetOrdersCircleIndicator,
        showNoInternetPage: showGetOrdersNoInternetPage,
      );
    }, (getOrdersData) {
      ordersData = getOrdersData;
      hideGetOrdersCircleIndicator();
      hideGetOrdersNoInternetPage();
    });
  }

  bool isGetOrderWithPaginationData = true;
///////////////////////////////////
  Future<void> getListOrderWithPaginationData({
    required String token,
    required String status,
  }) async {
    if (isGetOrderWithPaginationData == true) {
      if (orderNoMoreItems) {
        debugPrint('No More Items');
      } else {
        isGetOrderWithPaginationData = false;
        final failureOrGetOrdersData = await getListOrderDataProvider.call(
            token: token, status: status, offset: orderPaginationOffset);
        failureOrGetOrdersData.fold((failure) {
          HandlingFailures.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: () {},
            showNoInternetPage: () {},
          );
          isGetOrderWithPaginationData = true;
        }, (getOrdersData) {
          if (getOrdersData.data!.data!.isEmpty) {
            orderNoMoreItems = true;
            debugPrint('No More Items');
          } else {
            orderPaginationOffset++;
            ordersData!.data!.total = getOrdersData.data!.total;
            ordersData!.data!.data!.addAll(getOrdersData.data!.data!);
          }
          isGetOrderWithPaginationData = true;
          update();
        });
      }
    } else {
      debugPrint(
          '////////////////// Wait for request ////////////////////////////');
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
      HandlingFailures.networkErrorrHandling(
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
        myOrderStatus = orderStatusData[9].toString();
        selectedMyOrderStatus = 0;
      }

      ///
      isForAllOrders
          ? hideGetOrderStatusCircleIndicator()
          : hideGetMyOrderStatusCircleIndicator();
      isForAllOrders
          ? hideGetOrderStatusNoInternetPage()
          : hideGetMyOrderStatusNoInternetPage();

      if (isForAllOrders) {
        await getListOrderData(token: token, status: orderStatus, offset: 1);
      } else {
        await getMyOrdersData(token: token, status: myOrderStatus, offset: 1);
        // if (GlobalFunctions.getisForAssignOrderToMe()) {
        //   await GlobalFunctions.setisForAssignOrderToMe(
        //           isForAssignOrderToMe: false)
        //       .then(
        //     (value) async {
        //       await chooseMyOrderStatus(
        //         status: OrderStatuses.readyToShipping,
        //         index: 0,
        //         isForAssignToMe: true,
        //       );
        //     },
        //   );
        // } else {
        //   await getMyOrdersData(token: token, status: myOrderStatus, offset: 1);
        // }
      }
    });
  }

  Future<void> unAssignToVehicle(
      {required String token, required int vehicleId}) async {
    showUnAssignedCircleIndicator();
    final failureOrAssignToVehicle = await unAssignToVehicleProvider.call(
        token: token, vehicleId: vehicleId);

    failureOrAssignToVehicle.fold((failure) {
      HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideUnAssignedCircleIndicator,
          showNoInternetPage: () {});
    }, (getUnAssignToVehicleData) async {
      unAssignToVehicleData = getUnAssignToVehicleData;
      hideUnAssignedCircleIndicator();
      SnackBarWidgets.showSuccessSnackBar(
          'UnAssign To Vehicle Succeeded'.tr, '');
      await GlobalFunctions.setAssignVehicleToUserId(
          assignToUserId: unAssignToVehicleData.data!.assignToUserId ?? -1);
      update();
    });
  }

  Future<void> assignOrderToMe({
    required String token,
    required int orderId,
  }) async {
    showAssignUnAssignOrderCircleIndicator();
    final failureOrAssignToVehicle =
        await assignOrderToMeProvider.call(token: token, orderId: orderId);

    failureOrAssignToVehicle.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideAssignUnAssignOrderCircleIndicator,
          showNoInternetPage: () {},
        );
      },
      (data) async {
        assignOrderToMeData = data;
        hideAssignUnAssignOrderCircleIndicator();
        SnackBarWidgets.showSuccessSnackBar('Assign Order Succeeded'.tr, '');
        Get.close(1);
        await const Duration(milliseconds: 500).delay().then(
          (value) async {
            // await GlobalFunctions.setisForAssignOrderToMe(
            //     isForAssignOrderToMe: true);
            Get.offAllNamed(Routes.myOrdersPage);
          },
        );
      },
    );
  }

  UnAssignOrderToMeDataModel? unAssignOrderToMeData;

  Future<void> unAssignOrderToMe({
    required String token,
    required int orderId,
  }) async {
    showAssignUnAssignOrderCircleIndicator();
    final failureOrAssignToVehicle =
        await unAssignOrderToMeProvider.call(token: token, orderId: orderId);

    failureOrAssignToVehicle.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideAssignUnAssignOrderCircleIndicator,
          showNoInternetPage: () {},
        );
      },
      (data) async {
        unAssignOrderToMeData = data;

        hideAssignUnAssignOrderCircleIndicator();
        SnackBarWidgets.showSuccessSnackBar(
            'Process Completed Successfuly'.tr, '');

        Get.close(1);

        await const Duration(milliseconds: 5).delay().then(
          (value) {
            myOrdersData!.data!.data!
                .removeWhere((element) => element.id == orderId);
            update();
          },
        );
      },
    );
  }

  Future<void> startUploadFileService() async {
    await BackGroundServiceUtils.service.isRunning().then((value) async {
      if (!value) {
        await BackGroundServiceUtils.service.startService();
      }
    });
  }

  Future<void> changeOrderStatus({
    required String token,
    required String status,
    required int orderId,
    double? amount,
    List<ProductModel>? returnedProducts,
  }) async {
    showChangeOrderStatusCircleIndicator();
    final failureOrData = await changeOrderStatusProvider.call(
      token: token,
      orderId: orderId,
      status: status,
      returnedProducts: returnedProducts,
      amount: amount,
    );

    failureOrData.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: hideChangeOrderStatusCircleIndicator,
            showNoInternetPage: () {});
      },
      (data) async {
        hideChangeOrderStatusCircleIndicator();
        SnackBarWidgets.showSuccessSnackBar(
            'Changing Order Status Succeeded'.tr, '');
        Get.close(1);
        /////////////////////////////////////
        if (status == OrderStatuses.delivered ||
            status == OrderStatuses.partialReturn ||
            status == OrderStatuses.returned ||
            status == OrderStatuses.failed) {
          /////////////////////////////////////
          await stopRecording().then(
            (value) async {
              final data = UploadVoiceModel(
                orderId: orderId,
                filePath: audioPath ?? '',
                // numberOfUploadTry: 0,
              );
              await GlobalFunctions.setLocalStorageData(
                infoData: data,
                fromJson: UploadVoiceModel.fromJson,
                key: 'upload_voice',
                maxNumberOfData: 100,
              );
              /////////////////////////////////////
              await startUploadFileService();
              /////////////////////////////////////
              changeDeliveringButton(true);
              audioPath = '';
            },
          );
        }

        if (status == OrderStatuses.partialReturn) {
          await chooseMyOrderStatus(
              status: status, index: selectedMyOrderStatus + 2);
        } else if (status == OrderStatuses.returned) {
          await chooseMyOrderStatus(
              status: status, index: selectedMyOrderStatus + 3);
        } else if (status == OrderStatuses.failed) {
          await chooseMyOrderStatus(
              status: status, index: selectedMyOrderStatus + 4);
        } else {
          await chooseMyOrderStatus(
              status: status, index: selectedMyOrderStatus + 1);
        }
      },
    );
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
      HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideGetMyOrdersCircleIndicator,
          showNoInternetPage: showGetMyOrdersNoInternetPage);
    }, (getOrdersData) {
      myOrdersData = getOrdersData;
      hideGetMyOrdersCircleIndicator();
      hideGetMyOrdersNoInternetPage();
    });
  }

  bool isGetMyOrderWithPaginationData = true;
/////////////////////////////////////
  Future<void> getMyOrdersWithPaginationData({
    required String token,
    required String status,
  }) async {
    if (isGetMyOrderWithPaginationData == true) {
      if (myOrderNoMoreItems) {
        debugPrint('No More Items');
      } else {
        isGetMyOrderWithPaginationData = false;
        final failureOrGetOrdersData = await getMyOrdersProvider.call(
            token: token, status: status, offset: myOrderPaginationOffset);
        failureOrGetOrdersData.fold(
          (failure) {
            HandlingFailures.networkErrorrHandling(
              failure: failure,
              hideCircleIndicator: () {},
              showNoInternetPage: () {},
            );
            isGetMyOrderWithPaginationData = true;
          },
          (getOrdersData) {
            if (getOrdersData.data!.data!.isEmpty) {
              myOrderNoMoreItems = true;
              debugPrint('No More Items');
            } else {
              myOrderPaginationOffset++;
              myOrdersData!.data!.total = getOrdersData.data!.total;
              myOrdersData!.data!.data!.addAll(getOrdersData.data!.data!);
            }
            isGetMyOrderWithPaginationData = true;
            update();
          },
        );
      }
    } else {
      debugPrint(
          '////////////////// Wait for request ////////////////////////////');
    }
  }

  Future<void> changeOrderReceivedAmount({
    required String token,
    required int orderId,
    required double receivedAmount,
  }) async {
    showAssignUnAssignOrderCircleIndicator();
    final failureOrData = await changeOrderReceivedAmountProvider.call(
      token: token,
      orderId: orderId,
      receivedAmount: receivedAmount,
    );

    failureOrData.fold((failure) {
      HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideAssignUnAssignOrderCircleIndicator,
          showNoInternetPage: () {});
    }, (data) async {
      bool test =
          myOrdersData!.data!.data!.any((element) => element.id == orderId);

      if (test) {
        myOrdersData!.data!.data!
            .firstWhere((element) => element.id == orderId)
            .receivedAmount = data.receivedAmount;

        myOrdersData!.data!.data!
            .firstWhere((element) => element.id == orderId)
            .paymentStatus = data.paymentStatus;
      }

      SnackBarWidgets.showSuccessSnackBar(
          'Process Completed Successfuly'.tr, '');

      hideAssignUnAssignOrderCircleIndicator();
    });
  }

  bool isGetOrderDetailsCircleShown = false;
  bool isGetOrderDetailsNoInternetShown = false;
  // ///////////////////////////
  void showGetOrderDetailsCircleIndicator() {
    if (isGetOrderDetailsCircleShown == false) {
      isGetOrderDetailsCircleShown = true;
      update(['all_order_details_page']);
    }
  }

  void hideGetOrderDetailsCircleIndicator() {
    if (isGetOrderDetailsCircleShown == true) {
      isGetOrderDetailsCircleShown = false;
      update(['all_order_details_page']);
    }
  }

  // ///////////////////////////
  void showGetOrderDetailsNoInternetPage() {
    if (isGetOrderDetailsNoInternetShown == false) {
      isGetOrderDetailsNoInternetShown = true;
      update(['all_order_details_page']);
    }
  }

  void hideGetOrderDetailsNoInternetPage() {
    if (isGetOrderDetailsNoInternetShown == true) {
      isGetOrderDetailsNoInternetShown = false;
      update(['all_order_details_page']);
    }
  }

  OrderDataModel? orderDetails;

  // ///////////////////////////////////
  Future<void> getOrderDetailsData({
    required String token,
    required int orderId,
    required bool isForMyOrder,
  }) async {
    showGetOrderDetailsCircleIndicator();

    final failureOrGetOrderDetailsData =
        await getOrderDetailsProvider.call(token: token, orderId: orderId);
    failureOrGetOrderDetailsData.fold((failure) {
      HandlingFailures.networkErrorrHandling(
        failure: failure,
        hideCircleIndicator: hideGetOrderDetailsCircleIndicator,
        showNoInternetPage: GlobalFunctions.getIsFromNotifiForNewOrder()
            ? showGetOrderDetailsNoInternetPage
            : () {},
      );
    }, (data) async {
      if (!GlobalFunctions.getIsFromNotifiForNewOrder()) {
        if (isForMyOrder) {
          OrderDataModel item = myOrdersData!.data!.data!
              .firstWhere((element) => element.id == orderId);

          int index = myOrdersData!.data!.data!.indexOf(item);
          myOrdersData!.data!.data![index] = data.data!;
        } else {
          OrderDataModel item = ordersData!.data!.data!
              .firstWhere((element) => element.id == orderId);

          int index = ordersData!.data!.data!.indexOf(item);
          ordersData!.data!.data![index] = data.data!;
        }
      } else {
        orderDetails = data.data;
      }
      ///////////////////////////////////////////////////
      hideGetOrderDetailsCircleIndicator();
      GlobalFunctions.getIsFromNotifiForNewOrder()
          ? hideGetOrderDetailsNoInternetPage()
          : null;
    });
  }
}
