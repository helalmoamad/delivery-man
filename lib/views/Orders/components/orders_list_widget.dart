import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderList extends StatelessWidget {
  final OrdersController ordersController;

  const OrderList({super.key, required this.ordersController});

  @override
  Widget build(BuildContext context) {
    final orders = ordersController.ordersData.data!.data!;
    return orders.isEmpty
        ? const Center(child: Text('Data Is Empty'))
        : ListView.separated(
            controller: ordersController.orderScrollController,
            itemCount: orders.length + 1,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return OrderWidget(
                    orders: orders,
                    index: index,
                    onTapViewDetails: () {
                      ordersController.orderIndex = index;
                      ordersController.previousRoute = Get.currentRoute;
                      Get.toNamed(Routes.ordersDetailsPage);
                    });
              } else {
                if (orders.length > 4) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: ordersController.orderNoMoreItems
                          ? Text('No More Items'.tr)
                          : const CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
          );
  }
}
