import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/cash_dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/order_statuses.dart';

class ReadyToShippingButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  ReadyToShippingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderId;
    final OrderDataModel order;
    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      orderId = int.parse(GlobalFunctions.getOrderId() ?? '-1');
      order = ordersController.orderDetails!;
    } else {
      if (ordersController.previousRoute == Routes.myOrdersPage) {
        orderId = ordersController.myOrderIdForDetails;
        order = ordersController.myOrdersData!.data!.data!
            .firstWhere((element) => element.id! == orderId);
      } else {
        orderId = ordersController.orderIdForDetails;
        order = ordersController.ordersData!.data!.data!
            .firstWhere((element) => element.id! == orderId);
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.normalButton(
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
              AppDialogs.showConfirmationDialog(
                context: context,
                title: 'The order  will be assigned to you'.tr,
                onConfirm: () async {
                  Get.back();
                  await ordersController.assignOrderToMe(
                      token: GlobalFunctions.getToken(), orderId: order.id!);
                },
              );
            } else {
              AppDialogs.showConfirmationDialog(
                context: context,
                title: 'The order status will be changed to "shipped"'.tr,
                onConfirm: () async {
                  Get.back();
                  await ordersController.changeOrderStatus(
                    token: GlobalFunctions.getToken(),
                    status: OrderStatuses.shipped,
                    orderId: order.id!,
                  );
                },
              );
            }
          },
        ),
        ////////////////////////
        GlobalFunctions.getUserId() == order.assignToUserId
            ? const SizedBox(
                height: 10,
              )
            : Container(),
        ////////////////////////
        GlobalFunctions.getUserId() == order.assignToUserId
            ? AppButton.normalButton(
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
                            String token = GlobalFunctions.getToken();
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
              )
            : Container(),
      ],
    );
  }
}
