import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import 'components/orders_list_widget.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});
  final OrdersController ordersController = Get.find<OrdersController>();
  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "OrdersPage");
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      final log = await DeviceInfoHelper.createErrorLog(
          errorType: "Flutter Error",
          lastFourPageVisited: lastFourPageVisited,
          errorPath: lastFourPageVisited.last ?? "",
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
                  await ordersController.getListOrderData(
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
                        await ordersController.getListOrderData(
                          token: token,
                          status: ordersController.orderStatus,
                          offset: 1,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 55, top: 5),
                        child: OrderList(ordersController: ordersController),
                      ),
                    ),
                    //////////////////////////////
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomNavBar(
                          key: const Key("ReturnedOrders"),
                          isColored1: true,
                          isColored2: false,
                          isColored3: false,
                          coloredIcon1: 'assets/pictures/all orders red.png',
                          coloredIcon2: 'assets/pictures/my orders red.png',
                          coloredIcon3: 'assets/pictures/Return-Icon red.png',
                          text1: 'All Orders'.tr,
                          text2: 'MyOrders'.tr,
                          text3: 'Returned Orders'.tr,
                          unColoredIcon1: 'assets/pictures/all orders grey.png',
                          unColoredIcon2: 'assets/pictures/my orders grey.png',
                          unColoredIcon3: 'assets/pictures/return grey.png',
                          onTap1: () {},
                          onTap2: () {
                            ordersController.myOrderStatus = '';
                            Get.offAllNamed(Routes.myOrdersPage);
                          },
                          onTap3: () {
                            ordersController.myOrderStatus = '';
                            ordersController.previousRoute = Get.currentRoute;
                            Get.offAllNamed(Routes.returnedOrders);
                            print(
                                "Previous Route: ${ordersController.previousRoute}");
                            print("Current Route: ${Get.currentRoute}");
                          },
                          key3: const Key('returnedOrdersButton'),
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
      title: 'All Orders'.tr,
      button: GetBuilder<OrdersController>(
        builder: (_) {
          return AppButton.normalButton(
            title: GlobalFunctions.getAssignVehicleToUserId() == -1
                ? 'Assign to vehicle'.tr
                : '${'UnAssign'.tr} ${GlobalFunctions.getAssignVehicleToUserId() != -1 ? GlobalFunctions.getAssignedVehicleName() : ''}',
            height: 40,
            titleSize: 13,
            backgroundColor: GlobalFunctions.getAssignVehicleToUserId() == -1
                ? AppColors.secondary
                : AppColors.darkGrey,
            onPress: () async {
              if (GlobalFunctions.getAssignVehicleToUserId() == -1) {
                Get.toNamed(Routes.scanQRPage);
              } else {
                AppDialogs.showConfirmationDialog(
                  context: context,
                  title:
                      'Are you sure you want to unassign to the vehicle ?'.tr,
                  onConfirm: () async {
                    Get.back();
                    await ordersController.unAssignToVehicle(
                        token: GlobalFunctions.getToken(),
                        vehicleId: GlobalFunctions.getAssignedVehicleId());
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
