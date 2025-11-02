import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/circle_indecator_widget.dart';
import 'package:delivery_man_app/shared/widgets/custom_navbar.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:delivery_man_app/views/Returned%20orders/returnedOrdersList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../controllers/Orders/orders_controller.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';

class ReturnedOrdersPage extends StatelessWidget {
  ReturnedOrdersPage({super.key});
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "ReturnedOrdersPage");
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      final log = await DeviceInfoHelper.createErrorLog(
          errorType: "Type:${details.exception.runtimeType.toString()} ${details.exceptionAsString().toString()}",
          lastFourPageVisited: lastFourPageVisited,
          errorPath: details.stack.toString(),
          lastApiRequest: '');
      await errorSender.sendError(log);
      await Sentry.captureException(details.exception,
          stackTrace: details.stack);
    };

    return SafeArea(
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          bool test = false;
          AppDialogs.showConfirmationDialog(
            context: context,
            title: 'Are you sure to exit the application ?'.tr,
            onConfirm: () {
              test = true;
              Get.back();
              SystemNavigator.pop();
            },
            onBackActions: () {
              test = false;
              Get.back();
            },
          );
          return test;
        },
        child: Scaffold(
          appBar: buildAppBar(context),
          drawer: CustomDrawer(),
          body: GetBuilder<OrdersController>(
            builder: (_) {
              return HandlingFailures.pageErrorHandling(
                isCircleShown: ordersController.isGetOrdersCircleShown,
                isNoInternetConnection:
                    ordersController.isGetOrdersNoInternetConnection,
                onTapTry: () async {
                  String token = GlobalFunctions.getToken();
                  await ordersController.getListReturnedOrderData(
                      token: token,
                      status: ordersController.orderStatus,
                      offset: 1);
                },
                page: Stack(
                  children: [
                    RefreshIndicator(
                      color: AppColors.primaryDark,
                      onRefresh: () async {
                        debugPrint('refresh');
                        String token = GlobalFunctions.getToken();
                        await ordersController.getListReturnedOrderData(
                          token: token,
                          status: ordersController.orderStatus,
                          offset: 1,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 55, top: 5),
                        child: ReturnedOrderList(ordersController: ordersController),
                      ),
                    ),
                    //////////////////////////////
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomNavBar(
                          isColored1: false,
                          isColored2: false,
                          isColored3: true,
                          coloredIcon1: 'assets/pictures/all orders red.png',
                          coloredIcon2: 'assets/pictures/my orders red.png',
                          coloredIcon3: 'assets/pictures/Return-Icon red.png',
                          text1: 'All Orders'.tr,
                          text2: 'MyOrders'.tr,
                          text3: 'Returned Orders'.tr,
                          unColoredIcon1: 'assets/pictures/all orders grey.png',
                          unColoredIcon2: 'assets/pictures/my orders grey.png',
                          unColoredIcon3: 'assets/pictures/return grey.png',
                          onTap1: () {
                            ordersController.myOrderStatus = '';
                            Get.offAllNamed(Routes.orderssPage);
                          },
                          onTap2: () {
                            Get.offAllNamed(Routes.myOrdersPage);
                          },
                          onTap3: () {},
                        )),
                    ///////////////////////////
                    GlobalFunctions.getAssignVehicleToUserId() == -1
                        ? Container(
                            color: Colors.black.withOpacity(0.8),
                          )
                        : Container(),
                    ////////////////////
                    GlobalFunctions.getAssignVehicleToUserId() == -1
                        ? Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenSizeUtils.getWidthInPercent(
                                      context, 15)),
                              child: TextWidget(
                                  text:
                                      'Assign to vehicle to be able to enter the app'
                                          .tr,
                                  color: AppColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.center,
                                  maxline: 4),
                            ),
                          )
                        : Container(),
                    //////////////////////
                    ordersController.isAnAssignedCircleShown
                        ? const CircleIndicatorWidget()
                        : Container(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return customAppBar(
      title: 'Returned Orders'.tr,
      // button: GetBuilder<OrdersController>(
      //   builder: (_) {
      //     return AppButton.normalButton(
      //       title: GlobalFunctions.getAssignVehicleToUserId() == -1
      //           ? 'Assign to vehicle'.tr
      //           : '${'UnAssign'.tr} ${GlobalFunctions.getAssignVehicleToUserId() != -1 ? GlobalFunctions.getAssignedVehicleName() : ''}',
      //       height: 40,
      //       titleSize: 13,
      //       backgroundColor: GlobalFunctions.getAssignVehicleToUserId() == -1
      //           ? AppColors.secondary
      //           : AppColors.darkGrey,
      //       onPress: () async {
      //         if (GlobalFunctions.getAssignVehicleToUserId() == -1) {
      //           Get.toNamed(Routes.scanQRPage);
      //         } else {
      //           AppDialogs.showConfirmationDialog(
      //             context: context,
      //             title:
      //                 'Are you sure you want to unassign to the vehicle ?'.tr,
      //             onConfirm: () async {
      //               Get.back();
      //               await ordersController.unAssignToVehicle(
      //                   token: GlobalFunctions.getToken(),
      //                   vehicleId: GlobalFunctions.getAssignedVehicleId());
      //             },
      //           );
      //         }
      //       },
      //     );
      //   },
      // ),
      button: GetBuilder<OrdersController>(
      builder: (_) {
        bool isAssigned = GlobalFunctions.getAssignVehicleToUserId() != -1;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 1.2,
              child: SizedBox(
                height: 25, 
                child: Switch(
                  value: isAssigned,
                  onChanged: (value) async {
                    if (!value) {
                      AppDialogs.showConfirmationDialog(
                        context: context,
                        title:
                            'Are you sure you want to unassign to the vehicle ?'
                                .tr,
                        onConfirm: () async {
                          Get.back();
                          await ordersController.unAssignToVehicle(
                            token: GlobalFunctions.getToken(),
                            vehicleId: GlobalFunctions.getAssignedVehicleId(),
                          );
                        },
                      );
                    } else {
                      Get.toNamed(Routes.scanQRPage);
                    }
                  },
                  activeColor: const Color.fromARGB(255, 23, 151, 11),
                  inactiveThumbColor: const Color.fromARGB(255, 255, 36, 2),
                ),
              ),
            ),
            SizedBox(height: 2,),
            Text(
              isAssigned
                  ? '${'UnAssign'.tr} ${GlobalFunctions.getAssignedVehicleName()}'
                  : 'Assign to vehicle'.tr,
              style: TextStyle(
                fontSize: 12,
                color: isAssigned
                    ? const Color.fromARGB(255, 23, 151, 11)
                    : const Color.fromARGB(255, 255, 36, 2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    ),
    );
  }
}
