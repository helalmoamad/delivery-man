import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/services/service_provider.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/empty_data_widget.dart';
import 'package:delivery_man_app/shared/widgets/order_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class MyOrderList extends StatelessWidget {
  final OrdersController ordersController;
  const MyOrderList({super.key, required this.ordersController});

  @override
  Widget build(BuildContext context) {
     PagesMonitor.addPageToList(page: "MyOrderList");
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      final log = await DeviceInfoHelper.createErrorLog(
          errorType: "Flutter Error",
          lastFourPageVisited: lastFourPageVisited,
          errorPath: lastFourPageVisited.last ?? "",
          lastApiRequest: '');
      await errorSender.sendError(log);
      await Sentry.captureException(details.exception,
          stackTrace: details.stack);
    };
    final orders = ordersController.myOrdersData!.data!.data!;
    return orders.isEmpty
        ? EmptyDataWidget(
            onTap: () async {
              String token = GlobalFunctions.getToken();
              await ordersController.getMyOrdersData(
                  token: token,
                  status: ordersController.myOrderStatus,
                  offset: 1);
            },
          )
        : ListView.separated(
            controller: ordersController.myOrderScrollController,
            itemCount: orders.length + 1,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return OrderWidget(
                    orders: orders,
                    index: index,
                    onTapViewDetails: () async {
                      ordersController.myOrderIdForDetails = orders[index].id!;
                      ordersController.myOrderIdInMarket =
                          orders[index].originalOrderId!;
                        ordersController.currentOrder = orders[index];

                      GetIt.I<PrefsRepository>().setOrderDetailsId(
                          orders[index].originalOrderId!.toString());
                      await GlobalFunctions.setIsFromNotifiForNewOrder(
                          isFromNotifiForNewOrder: false);
                      GetIt.I<PrefsRepository>().setMyOrderIdForChat("");
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
