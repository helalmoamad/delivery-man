import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/cash_dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippedButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  ShippedButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderIndex = ordersController.myOrderIndex;
    OrderModel order = ordersController.myOrdersData.data!.data![orderIndex];
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
                  token: GlobalFunctions.getFcmToken(),
                  status: 'out_for_delivery',
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
        AppButton.normalButton(
          title: 'Add Received Amount'.tr,
          height: 40,
          titleSize: 15,
          shadow: false,
          backgroundColor: AppColors.primaryDark,
          onPress: () {
            AppDialogs.showAppDialogWidget(
              context: context,
              title: 'Enter The Cash Amount'.tr,
              actions: [
                buildCashDialogAction(
                  cashKey: cashKey,
                  formKey: formKey,
                  onPress: () async {
                    if (formKey.currentState!.validate()) {
                      Get.back();
                      /////////////////////////////////
                      String token = GlobalFunctions.getFcmToken();
                      await ordersController.changeOrderReceivedAmount(
                        token: token,
                        orderId: order.id!,
                        receivedAmount: double.parse(cashKey.text),
                      );
                    }
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
