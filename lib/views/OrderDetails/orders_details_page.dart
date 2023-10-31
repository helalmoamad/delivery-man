import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/circle_indecator_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/widgets/custom_app_bar.dart';
import 'components/order_details.dart';

class OrdersDetailsPage extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  OrdersDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String status;
    if (Get.previousRoute == Routes.myOrdersPage) {
      status = ordersController.myOrderStatus;
    } else {
      status = ordersController.orderStatus;
    }
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        ordersController.changeDeliveringButton(true);
        if (Get.previousRoute == Routes.myOrdersPage) {}
        debugPrint('previousRoute is ${Get.previousRoute}');

        return true;
      },
      child: Scaffold(
          appBar: customAppBar(title: 'Order Details'.tr, button: Container()),
          body: GetBuilder<OrdersController>(builder: (_) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                OrderDetails(),
                //////////////////////
                if (status == 'ready_to_shipping' ||
                    status == 'shipped' ||
                    status == 'out_for_delivery')
                  Container(
                    width: double.infinity,
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.darkWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2), // Shadow color with opacity
                          spreadRadius: 3, // Spread radius
                          blurRadius: 12, // Blur radius
                          offset: const Offset(
                              0, -1), // Offset to create a top shadow
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Center(
                          child: GlobalFunctions.chooseStatusButtons(
                              inputText: status),
                        )),
                  ),

                ordersController.isAssignOrderCircleShown ||
                        ordersController.isChangeOrderStatusCircleShown
                    ? const CircleIndicatorWidget()
                    : Container(),
              ],
            );
          })),
    ));
  }
}
