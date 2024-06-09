import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/handling_errors.dart/handling_errors.dart';
import 'package:delivery_man_app/shared/widgets/custom_drawer.dart';
import 'package:delivery_man_app/shared/widgets/custom_navbar.dart';
import 'package:delivery_man_app/views/MyOrders/components/myorder_status_widget.dart';
import 'package:delivery_man_app/views/MyOrders/components/myorders_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../shared/widgets/app_dialogs.dart';
import '../../shared/widgets/custom_app_bar.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            appBar: customAppBar(title: 'MyOrders'.tr, button: Container()),
            drawer: CustomDrawer(),
            body: GetBuilder<OrdersController>(builder: (_) {
              return HandlingErrors.pageErrorHandling(
                isCircleShown: ordersController.isGetMyOrderStatusCircleShown,
                isNoInternetConnection:
                    ordersController.isGetMyOrderStatusNoInternetConnection,
                onTapTry: () async {
                  String token = GlobalFunctions.getFcmToken();
                  await ordersController.getOrderStatusData(
                      token: token, isForAllOrders: false);
                },
                page: Stack(
                  children: [
                    RefreshIndicator(
                      color: AppColors.primaryDark,
                      onRefresh: () async {
                        debugPrint('refresh');
                        String token = GlobalFunctions.getFcmToken();
                        await ordersController.getOrderStatusData(
                            token: token, isForAllOrders: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 55),
                        child: Column(
                          children: [
                            MyOrderStatusWidget(
                                ordersController: ordersController),
                            ////////////////////////////////////
                            Expanded(
                              child: HandlingErrors.pageErrorHandling(
                                isCircleShown:
                                    ordersController.isGetMyOrdersCircleShown,
                                isNoInternetConnection: ordersController
                                    .isGetMyOrdersNoInternetConnection,
                                onTapTry: () async {
                                  String token = GlobalFunctions.getFcmToken();
                                  await ordersController.getMyOrdersData(
                                      token: token,
                                      status: ordersController.myOrderStatus,
                                      offset: 1);
                                },
                                page: MyOrderList(
                                    ordersController: ordersController),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //////////////////////////////
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomNavBar(
                          isColored1: false,
                          isColored2: true,
                          coloredIcon1: 'assets/pictures/all orders red.png',
                          coloredIcon2: 'assets/pictures/my orders red.png',
                          text1: 'All Orders'.tr,
                          text2: 'MyOrders'.tr,
                          unColoredIcon1: 'assets/pictures/all orders grey.png',
                          unColoredIcon2: 'assets/pictures/my orders grey.png',
                          onTap1: () {
                            Get.offAllNamed(Routes.orderssPage);
                          },
                          onTap2: () {},
                        )),
                    ///////////////////////////
                  ],
                ),
              );
            })),
      ),
    );
  }
}
