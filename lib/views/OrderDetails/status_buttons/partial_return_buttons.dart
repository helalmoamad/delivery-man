import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/Orders/orders_controller.dart';
import '../../../models/Orders/list_order_model.dart';
import 'received_amount_button.dart';

class PartialReturnButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  PartialReturnButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderId = ordersController.myOrderIdForDetails;
    OrderDataModel order = ordersController.myOrdersData!.data!.data!
        .firstWhere((element) => element.id! == orderId);
    return ReceivedAmountButton(
      ordersController: ordersController,
      formKey: formKey,
      cashKey: cashKey,
      orderId: order.id!,
    );
  }
}
