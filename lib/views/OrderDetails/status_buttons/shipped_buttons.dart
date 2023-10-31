import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippedButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  ShippedButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderIndex = ordersController.myOrderIndex;
    Order order = ordersController.myOrdersData.data!.data![orderIndex];
    return AppButton.normalButton(
        title: 'Convert To Out For Delivery'.tr,
        height: 40,
        titleSize: 15,
        backgroundColor: AppColors.secondary,
        onPress: () async {
          await ordersController.changeOrderStatus(
              token: GlobalFunctions.getFcmToken(),
              status: 'out_for_delivery',
              orderId: order.id!,
              amount: 0,
              file: null);
        });
  }
}
