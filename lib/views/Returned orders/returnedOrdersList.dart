import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/empty_data_widget.dart';
import 'package:delivery_man_app/shared/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/Orders/orders_controller.dart';


class ReturnedOrderList extends StatelessWidget {
  final OrdersController ordersController;

  const ReturnedOrderList({super.key, required this.ordersController});

  @override
  @override
Widget build(BuildContext context) {
  final ordersData = ordersController.ordersData;
  final orders = ordersData?.data?.data;

  if (orders == null || orders.isEmpty) {
    return EmptyDataWidget(
      onTap: () async {
        String token = GlobalFunctions.getToken();
        await ordersController.getListReturnedOrderData(
          token: token,
          status: ordersController.orderStatus,
          offset: 1,
        );
      },
    );
  }

  return ListView.separated(
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
            ordersController.currentOrder = orders[index];
            await GlobalFunctions.setIsFromNotifiForNewOrder(isFromNotifiForNewOrder: false);
            GetIt.I<PrefsRepository>().setMyOrderIdForChat("");

            ordersController.previousRoute = Get.currentRoute;
            Get.toNamed(Routes.ordersDetailsPage);
          },
        );
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
      return const SizedBox(height: 10);
    },
  );
}

}
