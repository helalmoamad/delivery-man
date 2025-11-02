// import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
// import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
// import 'package:delivery_man_app/main.dart';
// import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
// import 'package:delivery_man_app/message_error_log/device_info_util.dart';
// import 'package:delivery_man_app/routes/routes.dart';
// import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
// import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_it/get_it.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
// import '../../../controllers/Client/client_controller.dart';
// import '../../../controllers/Client/timer_service.dart';
// import '../../../shared/constants/color_constants.dart';
// import '../../../shared/widgets/text_widget.dart';

// class MyOrderStatusWidget extends StatefulWidget {
//   final OrdersController ordersController;
//   final HttpClientService httpClientController = Get.find<HttpClientService>();
//   final TimerService timerService = Get.find<TimerService>();
//   MyOrderStatusWidget({
//     super.key,
//     required this.ordersController,
//   });

//   @override
//   State<MyOrderStatusWidget> createState() => _OrdersDetailsPageState();
// }

// class _OrdersDetailsPageState extends State<MyOrderStatusWidget> {
//   @override
//   void initState() {
//     /*  if (GetIt.I<PrefsRepository>().myOrderIdForChat != "" &&
//         GetIt.I<PrefsRepository>().myOrderIdForChat != null) {
//       Future.delayed(
//         const Duration(seconds: 10),
//         () async {
//           ////  widget.httpClientController.closeSecondaryClient();
//           ////widget.timerService.stopTimer(isGlobalTimer: false);
//           /////////////////////////////////////////////////////
//           //print(ordersController.orderStatusData[index + 9].toString());
//           await widget.ordersController.chooseMyOrderStatus(
//               id: "209",
//               isForChat: true,
//               status: "out_for_delivery",
//               index: (widget.ordersController.orderStatusData
//                       .indexOf("out_for_delivery")) -
//                   9);
//           final orders = widget.ordersController.myOrderForChatData!.data;
//           widget.ordersController.orderDetails =
//               widget.ordersController.myOrderForChatData?.data;
//           widget.ordersController.myOrderIdForDetails = orders!.id!;
//           GlobalFunctions.setOrderId(orderId: orders.id.toString());
//           widget.ordersController.myOrderIdInMarket = orders.originalOrderId!;
//           GetIt.I<PrefsRepository>()
//               .setOrderDetailsId(orders.originalOrderId!.toString());
//           await GlobalFunctions.setIsFromNotifiForNewOrder(
//               isFromNotifiForNewOrder: true);
//           widget.ordersController.previousRoute = Get.currentRoute;
//           Get.toNamed(
//             Routes.ordersDetailsPage,
//           );
//         },
//       );
//     }*/

//     super.initState();
//     PagesMonitor.addPageToList(page: "MyOrderStatus");
//     FlutterError.onError = (details) async {
//       FlutterError.presentError(details);
//       final log = await DeviceInfoHelper.createErrorLog(
//           errorType: "Flutter Error",
//           lastFourPageVisited: lastFourPageVisited,
//           errorPath: lastFourPageVisited.last ?? "",
//           lastApiRequest: '');
//       await errorSender.sendError(log);
//       await Sentry.captureException(details.exception,
//           stackTrace: details.stack);
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//       child: SizedBox(
//           height: 35,
//           child: ScrollablePositionedList.separated(
//             itemScrollController: myOrderStatusScrollController,
//             itemCount: widget.ordersController.orderStatusData.length - 9,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 key: Key(
//                     'orderStatus_${widget.ordersController.orderStatusData[index + 9]}'),
//                 onTap: () async {
//                   widget.httpClientController.closeSecondaryClient();
//                   widget.timerService.stopTimer(isGlobalTimer: false);
//                   /////////////////////////////////////////////////////
//                   //print(ordersController.orderStatusData[index + 9].toString());
//                   await widget.ordersController.chooseMyOrderStatus(
//                     status: widget.ordersController.orderStatusData[index + 9]
//                         .toString(),
//                     index: index,
//                   );

//                   debugPrint(widget.ordersController.myOrderStatus);

//                   debugPrint(index.toString());
//                 },
//                 child: SizedBox(
//                   height: 33,
//                   width: ScreenSizeUtils.getWidthInPercent(context, 35),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       TextWidget(
//                           text: GlobalFunctions.orderStatusText(
//                               inputText: widget
//                                   .ordersController.orderStatusData[index + 9]
//                                   .toString()),
//                           color: AppColors.blackDark,
//                           fontSize: 15,
//                           fontWeight: index ==
//                                   widget.ordersController.selectedMyOrderStatus
//                               ? FontWeight.bold
//                               : FontWeight.normal,
//                           textAlign: TextAlign.center,
//                           maxline: 1),

//                       ///////////
//                       index == widget.ordersController.selectedMyOrderStatus
//                           ? Container(
//                               height: 2,
//                               color: AppColors.primaryDark,
//                             )
//                           : Container()
//                     ],
//                   ),
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) {
//               return const SizedBox(
//                 width: 5,
//               );
//             },
//           )),
//     );
//   }
// }
import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MyOrderStatusWidget extends StatefulWidget {
  final OrdersController ordersController;

  const MyOrderStatusWidget({
    Key? key,
    required this.ordersController,
  }) : super(key: key);

  @override
  State<MyOrderStatusWidget> createState() => _OrdersDetailsPageState();
}

class _OrdersDetailsPageState extends State<MyOrderStatusWidget> {
  final ItemScrollController myOrderStatusScrollController =
      ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ScrollablePositionedList.separated(
          itemScrollController: myOrderStatusScrollController,
          itemCount: widget.ordersController.orderStatusData.length - 9,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            bool isSelected =
                index == widget.ordersController.selectedMyOrderStatus;

            return InkWell(
              key: Key(
                  'orderStatus_${widget.ordersController.orderStatusData[index + 9]}'),
              onTap: () async {
                await widget.ordersController.chooseMyOrderStatus(
                  status: widget.ordersController.orderStatusData[index + 9]
                      .toString(),
                  index: index,
                );
              },
              borderRadius: BorderRadius.circular(12),
              splashColor: AppColors.primaryDark.withOpacity(0.2),
              highlightColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsetsGeometry.only(bottom: 3),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextWidget(
                        text: GlobalFunctions.orderStatusText(
                          inputText: widget
                              .ordersController.orderStatusData[index + 9]
                              .toString(),
                        ),
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.blackDark,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        textAlign: TextAlign.center,
                        maxline: 1,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(top: 3),
                      height: 3,
                      width: ScreenSizeUtils.getWidthInPercent(context, 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryDark
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 6),
        ),
      ),
    );
  }
}
