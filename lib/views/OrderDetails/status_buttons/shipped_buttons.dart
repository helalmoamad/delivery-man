import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/order_statuses.dart';
import 'received_amount_button.dart';

class ShippedButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  ShippedButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderId = ordersController.myOrderIdForDetails;
    OrderDataModel order = ordersController.myOrdersData!.data!.data!
        .firstWhere((element) => element.id! == orderId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.normalButton(
          title: 'Convert To Out For Delivery'.tr,
          height: 40,
          titleSize: 15,
          backgroundColor: AppColors.darkGrey,
          onPress: () async {
            AppDialogs.showConfirmationDialog(
              context: context,
              title:
                  'The order status will be changed to "Out For Delivery"'.tr,
              onConfirm: () async {
                Get.back();
                await ordersController.changeOrderStatus(
                  token: GlobalFunctions.getToken(),
                  status: OrderStatuses.outForDelivery,
                  orderId: order.id!,
                );
              },
            );
          },
        ),
        ////////////////////////
        const SizedBox(
          height: 10,
        ),
        ////////////////////////
        ReceivedAmountButton(
          ordersController: ordersController,
          formKey: formKey,
          cashKey: cashKey,
          orderId: order.id!,
        )
      ],
    );
  }
}
