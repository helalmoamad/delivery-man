import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/empty_data_widget.dart';
import 'package:delivery_man_app/shared/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderList extends StatelessWidget {
  final OrdersController ordersController;

  const OrderList({super.key, required this.ordersController});

  @override
  Widget build(BuildContext context) {
    final orders = ordersController.ordersData!.data!.data!;
    return orders.isEmpty
        ? EmptyDataWidget(
            onTap: () async {
              String token = GlobalFunctions.getToken();
              await ordersController.getListOrderData(
                  token: token,
                  status: ordersController.orderStatus,
                  offset: 1);
            },
          )
        : ListView.separated(
            controller: ordersController.orderScrollController,
            itemCount: orders.length + 1,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return OrderWidget(
                    orders: orders,
                    index: index,
                    onTapViewDetails: () async {
                      ordersController.orderIdForDetails = orders[index].id!;
                      await GlobalFunctions.setIsFromNotifiForNewOrder(
                          isFromNotifiForNewOrder: false);
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
