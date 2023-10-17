import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/Orders/orders_controller.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import 'components/order_status_widget.dart';
import 'components/orders_list_widget.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: GetBuilder<OrdersController>(builder: (_) {
        return HandlingErrors.pageErrorHandling(
          isCircleShown: ordersController.isGetOrderStatusCircleShown,
          isNoInternetConnection:
              ordersController.isGetOrderStatusNoInternetConnection,
          onTapTry: () async {
            String token = GlobalFunctions.getFcmToken();
            await ordersController.getOrderStatusData(token: token);
          },
          page: RefreshIndicator(
            color: AppColors.primaryDark,
            onRefresh: () async {
              debugPrint('refresh');
              String token = GlobalFunctions.getFcmToken();
              await ordersController.getOrderStatusData(token: token);
            },
            child: Column(
              children: [
                OrderStatusWidget(ordersController: ordersController),
                ////////////////////////////////////
                Expanded(
                  child: HandlingErrors.pageErrorHandling(
                    isCircleShown: ordersController.isGetOrdersCircleShown,
                    isNoInternetConnection:
                        ordersController.isGetOrdersNoInternetConnection,
                    onTapTry: () async {
                      String token = GlobalFunctions.getFcmToken();
                      await ordersController.getListOrderData(
                          token: token,
                          status: ordersController.orderStatus,
                          offset: 1);
                    },
                    page: OrderList(ordersController: ordersController),
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
