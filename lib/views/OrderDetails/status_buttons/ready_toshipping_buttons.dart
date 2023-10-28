import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadyToShippingButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  ReadyToShippingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderIndex = ordersController.orderIndex;
    final order = ordersController.ordersData.data!.data![orderIndex];
    return AppButton.normalButton(
        title: GlobalFunctions.getUserId() != order.assignToUserId
            ? 'Assign To Me'.tr
            : 'Convert To Shipped'.tr,
        height: 40,
        titleSize: 15,
        backgroundColor: GlobalFunctions.getUserId() != order.assignToUserId
            ? AppColors.secondary
            : AppColors.darkGrey,
        onPress: () async {
          if (GlobalFunctions.getUserId() != order.assignToUserId) {
          } else {}
        });
  }
}
