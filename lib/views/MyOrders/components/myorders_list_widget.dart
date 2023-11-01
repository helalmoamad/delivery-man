import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderList extends StatelessWidget {
  final OrdersController ordersController;

  const MyOrderList({super.key, required this.ordersController});

  @override
  Widget build(BuildContext context) {
    final orders = ordersController.myOrdersData.data!.data!;
    return orders.isEmpty
        ? const Center(child: Text('Data Is Empty'))
        : ListView.separated(
            controller: ordersController.myOrderScrollController,
            itemCount: orders.length + 1,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return OrderWidget(
                    orders: orders,
                    index: index,
                    onTapViewDetails: () {
                      ordersController.myOrderIndex = index;
                      ordersController.previousRoute = Get.currentRoute;
                      Get.toNamed(
                        Routes.ordersDetailsPage,
                      );
                    });
              } else {
                if (orders.length > 4) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: ordersController.myOrderNoMoreItems
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
