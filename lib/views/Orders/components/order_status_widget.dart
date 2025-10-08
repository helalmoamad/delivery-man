import 'package:delivery_man_app/controllers/Client/timer_service.dart';
import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../controllers/Client/client_controller.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class OrderStatusWidget extends StatelessWidget {
  final OrdersController ordersController;
  final HttpClientService httpClientController = Get.find<HttpClientService>();
  final TimerService timerService = Get.find<TimerService>();

  OrderStatusWidget({
    super.key,
    required this.ordersController,
  });

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "OrderStatusWidget");
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: SizedBox(
          height: 35,
          width: double.infinity,
          child: Row(
            children: [
              buildStatusContent(0),
              const SizedBox(
                width: 5,
              ),
              buildStatusContent(1),
              const SizedBox(
                width: 5,
              ),
              buildStatusContent(2),
            ],
          )),
    );
  }

  Widget buildStatusContent(int index) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          httpClientController.closeSecondaryClient();
          timerService.stopTimer(isGlobalTimer: false);
          /////////////////////////////////////////////////////
          await ordersController.chooseOrderStatus(
              status: ordersController.orderStatusData[index].toString(),
              index: index);

          debugPrint(ordersController.orderStatus);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextWidget(
                  text: GlobalFunctions.orderStatusText(
                      inputText:
                          ordersController.orderStatusData[index].toString()),
                  color: AppColors.blackDark,
                  fontSize: 15,
                  fontWeight: index == ordersController.selectedOrderStatus
                      ? FontWeight.bold
                      : FontWeight.normal,
                  textAlign: TextAlign.center,
                  maxline: 2),
            ),
            index == ordersController.selectedOrderStatus
                ? Container(
                    height: 2,
                    color: AppColors.primaryDark,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
