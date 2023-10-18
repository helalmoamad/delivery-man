import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/Orders/orders_controller.dart';
import '../../shared/widgets/custom_app_bar.dart';
import 'components/order_details.dart';

class OrdersDetailsPage extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  OrdersDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    int orderIndex = Get.arguments[0];
    final order = ordersController.ordersData.data!.orders![orderIndex];
    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(title: 'Order Details'.tr, actions: []),
            body: GetBuilder<OrdersController>(builder: (_) {
              return
                  // OrderDetails();
                  ListView.separated(
                itemCount: order.details!.length,
                itemBuilder: (context, index) {
                  return OrderDetails(detailsIndex: index);
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      height: 3,
                      width: double.infinity,
                      color: AppColors.primaryDark,
                    ),
                  );
                },
              );
            })));
  }
}
