import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../controllers/Orders/orders_controller.dart';
import '../../routes/routes.dart';
import '../../shared/constants/color_constants.dart';
import '../../shared/constants/order_statuses.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/widgets/circle_indecator_widget.dart';
import 'components/order_details.dart';

class OrderDetailsWithStatusButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  OrderDataModel? order;
  OrderDetailsWithStatusButtons({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String status;

    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      status = (GetIt.I<PrefsRepository>().myParentOrderIdForChat != "" &&
              GetIt.I<PrefsRepository>().myParentOrderIdForChat != null)
          ? OrderStatuses.returnedToDeliveryCenter
          : (GetIt.I<PrefsRepository>().myOrderIdForChat != "" &&
                  GetIt.I<PrefsRepository>().myOrderIdForChat != null)
              ? OrderStatuses.outForDelivery
              : OrderStatuses.inDeliveryCenter;
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
            if (status == OrderStatuses.inDeliveryCenter ||
                // status == OrderStatuses.shipped ||
                status == OrderStatuses.outForDelivery ||
                status == OrderStatuses.delivered ||
               
                // status == OrderStatuses.failed ||
                // status == OrderStatuses.canceled ||
                // status == OrderStatuses.canceledArchived

                status == OrderStatuses.returnedToDeliveryCenter)

              // centeres
              ////////////////////
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///

              ////////////////////////////////////////////////////////////////////////////////////

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
                        inputText: status,
                        isNotAssigned:
                            order?.assignToUserId == "" ? true : false,
                        hasParentOrderId:
                            order?.orderParentId != null ? true : false),
                  ),
                ),
              ),
            ////////////////////////////////////////////////////////
            ordersController.isAssignUnAssignOrderCircleShown ||
                    ordersController.isChangeOrderStatusCircleShown
                ? const CircleIndicatorWidget()
                : Container(),
          ],
        );
      },
    );
  }
}
