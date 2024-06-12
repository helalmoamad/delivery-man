import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/Orders/orders_controller.dart';
import '../../routes/routes.dart';
import '../../shared/constants/color_constants.dart';
import '../../shared/constants/order_statuses.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/widgets/circle_indecator_widget.dart';
import 'components/order_details.dart';

class OrderDetailsWithStatusButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  OrderDetailsWithStatusButtons({super.key});

  @override
  Widget build(BuildContext context) {
    String status;
    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      status = OrderStatuses.readyToShipping;
    } else {
      if (ordersController.previousRoute == Routes.myOrdersPage) {
        status = ordersController.myOrderStatus;
      } else {
        status = ordersController.orderStatus;
      }
    }
    return GetBuilder<OrdersController>(
      id: 'change_status',
      builder: (_) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            OrderDetails(),
            //////////////////////
            if (status == OrderStatuses.readyToShipping ||
                status == OrderStatuses.shipped ||
                status == OrderStatuses.outForDelivery)
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.darkWhite,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with opacity
                      spreadRadius: 3, // Spread radius
                      blurRadius: 12, // Blur radius
                      offset:
                          const Offset(0, -1), // Offset to create a top shadow
                    ),
                  ],
                ),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Center(
                      child: GlobalFunctions.chooseStatusButtons(
                          inputText: status),
                    )),
              ),
            ////////////////////////////////////////////////////////
            ordersController.isAssignOrderCircleShown ||
                    ordersController.isChangeOrderStatusCircleShown
                ? const CircleIndicatorWidget()
                : Container(),
          ],
        );
      },
    );
  }
}
