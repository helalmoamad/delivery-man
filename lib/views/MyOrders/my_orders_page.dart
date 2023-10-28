import 'package:delivery_man_app/controllers/MyOrders/myorders_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/handling_errors.dart/handling_errors.dart';
import 'package:delivery_man_app/views/MyOrders/components/myorder_status_widget.dart';
import 'package:delivery_man_app/views/MyOrders/components/myorders_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/widgets/custom_app_bar.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});
  final MyOrdersController myOrdersController = Get.find<MyOrdersController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: customAppBar(title: 'MyOrders'.tr, button: Container()),
          body: GetBuilder<MyOrdersController>(builder: (_) {
            return HandlingErrors.pageErrorHandling(
              isCircleShown: myOrdersController.isGetOrderStatusCircleShown,
              isNoInternetConnection:
                  myOrdersController.isGetOrderStatusNoInternetConnection,
              onTapTry: () async {
                String token = GlobalFunctions.getFcmToken();
                await myOrdersController.getOrderStatusData(token: token);
              },
              page: RefreshIndicator(
                color: AppColors.primaryDark,
                onRefresh: () async {
                  debugPrint('refresh');
                  String token = GlobalFunctions.getFcmToken();
                  await myOrdersController.getOrderStatusData(token: token);
                },
                child: Column(
                  children: [
                    MyOrderStatusWidget(myOrdersController: myOrdersController),
                    ////////////////////////////////////
                    Expanded(
                      child: HandlingErrors.pageErrorHandling(
                        isCircleShown:
                            myOrdersController.isGetMyOrdersCircleShown,
                        isNoInternetConnection: myOrdersController
                            .isGetMyOrdersNoInternetConnection,
                        onTapTry: () async {
                          String token = GlobalFunctions.getFcmToken();
                          await myOrdersController.getMyOrdersData(
                              token: token,
                              status: myOrdersController.orderStatus,
                              offset: 1);
                        },
                        page:
                            MyOrderList(myOrdersController: myOrdersController),
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
