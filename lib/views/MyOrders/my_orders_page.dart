import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/handling_errors.dart/handling_errors.dart';
import 'package:delivery_man_app/views/MyOrders/components/myorder_status_widget.dart';
import 'package:delivery_man_app/views/MyOrders/components/myorders_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/widgets/custom_app_bar.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: customAppBar(title: 'MyOrders'.tr, button: Container()),
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
              page: RefreshIndicator(
                color: AppColors.primaryDark,
                onRefresh: () async {
                  debugPrint('refresh');
                  String token = GlobalFunctions.getFcmToken();
                  await ordersController.getOrderStatusData(
                      token: token, isForAllOrders: false);
                },
                child: Column(
                  children: [
                    MyOrderStatusWidget(ordersController: ordersController),
                    ////////////////////////////////////
                    Expanded(
                      child: HandlingErrors.pageErrorHandling(
                        isCircleShown:
                            ordersController.isGetMyOrdersCircleShown,
                        isNoInternetConnection:
                            ordersController.isGetMyOrdersNoInternetConnection,
                        onTapTry: () async {
                          String token = GlobalFunctions.getFcmToken();
                          await ordersController.getMyOrdersData(
                              token: token,
                              status: ordersController.myOrderStatus,
                              offset: 1);
                        },
                        page: MyOrderList(ordersController: ordersController),
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
