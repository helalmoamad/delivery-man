import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/handling_errors.dart/handling_errors.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/constants/order_statuses.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/custom_app_bar.dart';
import 'order_details_with_status_buttons.dart';

class OrdersDetailsPage extends StatefulWidget {
  const OrdersDetailsPage({super.key});

  @override
  State<OrdersDetailsPage> createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<OrdersDetailsPage> {
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    //////////////
    getAllData();
  }

  void getAllData() async {
    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      String token = GlobalFunctions.getToken();
      //////////////////////////////////////////////////////////
      await ordersController.getOrderDetailsData(
        token: token,
        orderId: int.parse(GlobalFunctions.getOrderId() ?? '-1'),
        isForMyOrder: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          stopRecordingCondition(context);
          ///////////////////////////////////////
          debugPrint('previousRoute is ${ordersController.previousRoute}');
          ///////////////////////////////////////
          if (ordersController.isAssignUnAssignOrderCircleShown ||
              ordersController.isChangeOrderStatusCircleShown ||
              ordersController.isGetOrderDetailsCircleShown) {
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: buildAppBar(),
          body: GetBuilder<OrdersController>(
            id: 'all_order_details_page',
            builder: (_) {
              return HandlingFailures.pageErrorHandling(
                isCircleShown: ordersController.isGetOrderDetailsCircleShown,
                isNoInternetConnection:
                    GlobalFunctions.getIsFromNotifiForNewOrder()
                        ? ordersController.isGetOrderDetailsNoInternetShown
                        : false,
                onTapTry: () {
                  getAllData();
                },
                page: OrderDetailsWithStatusButtons(),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return customAppBar(
      title: 'Order Details'.tr,
      button: GetBuilder<OrdersController>(
        builder: (_) {
          if (ordersController.isRecording) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextWidget(
                    text: 'Recording . . .'.tr,
                    color: AppColors.blackDark,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    maxline: 1),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.settings_voice_outlined),
              ],
            );
          } else {
            if (ordersController.previousRoute == Routes.myOrdersPage) {
              String status = ordersController.myOrderStatus;
              return (status == OrderStatuses.readyToShipping) ||
                      (status == OrderStatuses.shipped) ||
                      (status == OrderStatuses.outForDelivery)
                  ? AppButton.normalButton(
                      title: 'UnAssign Order'.tr,
                      height: 40,
                      titleSize: 13,
                      backgroundColor: AppColors.secondary,
                      onPress: () async {
                        AppDialogs.showConfirmationDialog(
                          context: context,
                          title: 'Are you sure to unAssign the Order ?'.tr,
                          onConfirm: () async {
                            Get.back();
                            ///////////////////
                            int orderId = ordersController.myOrderIdForDetails;
                            String token = GlobalFunctions.getToken();
                            await ordersController.unAssignOrderToMe(
                              token: token,
                              orderId: orderId,
                            );
                          },
                        );
                      },
                    )
                  : Container();
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }

  void stopRecordingCondition(BuildContext context) {
    if ((ordersController.previousRoute == Routes.myOrdersPage) &&
        (ordersController.myOrderStatus == OrderStatuses.outForDelivery) &&
        (!ordersController.isStartDeliveryButton &&
            !GlobalFunctions.getIsFromNotifiForNewOrder())) {
      AppDialogs.showConfirmationDialog(
        context: context,
        title: 'Are you sure to stop recording and leave this page ?'.tr,
        onConfirm: () async {
          Get.back();
          Get.close(1);
          ordersController.changeDeliveringButton(true);
          await ordersController.stopRecording();
          ordersController.returnedProductsList.clear();
          ordersController.audioPath = '';
        },
      );
    }
  }
}
