import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/circle_indecator_widget.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_drawer.dart';
import 'components/order_status_widget.dart';
import 'components/orders_list_widget.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: customAppBar(
              title: 'Orders'.tr,
              button: GetBuilder<OrdersController>(builder: (_) {
                return
                    // InkWell(
                    //   onTap: () {
                    //     print(GlobalFunctions.getAssignToUserId());
                    //   },
                    //   child: Container(
                    //     width: 30,
                    //     height: 40,
                    //     color: GlobalFunctions.getAssignToUserId() == -1
                    //         ? Colors.red
                    //         : Colors.amber,
                    //   ),
                    // );
                    AppButton.normalButton(
                        title: GlobalFunctions.getAssignToUserId() == -1
                            ? 'Assign to vehicle'.tr
                            : '${'UnAssign'.tr} ${GlobalFunctions.getAssignToUserId() != -1 ? GlobalFunctions.getAssignedVehicleName() : ''}',
                        height: 40,
                        titleSize: 13,
                        backgroundColor:
                            GlobalFunctions.getAssignToUserId() == -1
                                ? AppColors.secondary
                                : AppColors.darkGrey,
                        onPress: () async {
                          if (GlobalFunctions.getAssignToUserId() == -1) {
                            Get.toNamed(Routes.scanQRPage);
                          } else {
                            // print(GlobalFunctions.getAssignToUserId());
                            await ordersController.unAssignToVehicle(
                                token: GlobalFunctions.getFcmToken(),
                                vehicleId:
                                    GlobalFunctions.getAssignedVehicleId());
                          }
                        });
              })),
          drawer: CustomDrawer(),
          body: GetBuilder<OrdersController>(builder: (_) {
            return HandlingErrors.pageErrorHandling(
              isCircleShown: ordersController.isGetOrderStatusCircleShown,
              isNoInternetConnection:
                  ordersController.isGetOrderStatusNoInternetConnection,
              onTapTry: () async {
                String token = GlobalFunctions.getFcmToken();
                await ordersController.getOrderStatusData(token: token);
              },
              page: Stack(
                children: [
                  RefreshIndicator(
                    color: AppColors.primaryDark,
                    onRefresh: () async {
                      debugPrint('refresh');
                      String token = GlobalFunctions.getFcmToken();
                      await ordersController.getOrderStatusData(token: token);
                    },
                    child: Column(
                      children: [
                        OrderStatusWidget(ordersController: ordersController),
                        ////////////////////////////////////
                        Expanded(
                          child: HandlingErrors.pageErrorHandling(
                            isCircleShown:
                                ordersController.isGetOrdersCircleShown,
                            isNoInternetConnection: ordersController
                                .isGetOrdersNoInternetConnection,
                            onTapTry: () async {
                              String token = GlobalFunctions.getFcmToken();
                              await ordersController.getListOrderData(
                                  token: token,
                                  status: ordersController.orderStatus,
                                  offset: 1);
                            },
                            page: OrderList(ordersController: ordersController),
                          ),
                        )
                      ],
                    ),
                  ),
                  ///////////////////////////
                  GlobalFunctions.getAssignToUserId() == -1
                      ? Container(
                          color: Colors.black.withOpacity(0.8),
                        )
                      : Container(),
                  ////////////////////
                  GlobalFunctions.getAssignToUserId() == -1
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenSizeUtils.getWidthInPercent(
                                    context, 15)),
                            child: TextWidget(
                                text:
                                    'Assign to vehicle to be able to enter the app'
                                        .tr,
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                                maxline: 4),
                          ),
                        )
                      : Container(),
                  //////////////////////
                  ordersController.isAnAssignedCircleShown
                      ? const CircleIndicatorWidget()
                      : Container(),
                ],
              ),
            );
          })),
    );
  }
}
