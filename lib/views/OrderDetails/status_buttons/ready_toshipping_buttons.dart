import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadyToShippingButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  ReadyToShippingButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderIndex;
    final OrderModel order;
    if (ordersController.previousRoute == Routes.myOrdersPage) {
      orderIndex = ordersController.myOrderIndex;
      order = ordersController.myOrdersData.data!.data![orderIndex];
    } else {
      orderIndex = ordersController.orderIndex;
      order = ordersController.ordersData.data!.data![orderIndex];
    }
    return AppButton.normalButton(
        title: GlobalFunctions.getUserId() != order.assignToUserId
            ? 'Assign To Me'.tr
            : 'Convert To Shipped'.tr,
        height: 40,
        titleSize: 15,
        backgroundColor: GlobalFunctions.getUserId() != order.assignToUserId
            ? AppColors.secondary
            : AppColors.darkGrey,
        onPress: () async {
          if (GlobalFunctions.getUserId() != order.assignToUserId) {
            AppDialogs.showAppDialogWidget(
              context: context,
              title: 'The order  will be assigned to you'.tr,
              actions: [
                AppButton.normalButton(
                  title: 'Confirm'.tr,
                  shadow: false,
                  width: ScreenSizeUtils.getWidthInPercent(context, 25),
                  height: 30,
                  titleColor: AppColors.white,
                  backgroundColor: AppColors.primaryDark,
                  onPress: () async {
                    Get.back();
                    await ordersController.assignOrderToMe(
                        token: GlobalFunctions.getFcmToken(),
                        orderId: order.id!);
                  },
                ),
                ///////////////
                AppButton.normalButton(
                    title: 'Back'.tr,
                    shadow: false,
                    width: ScreenSizeUtils.getWidthInPercent(context, 25),
                    backgroundColor: AppColors.white,
                    titleColor: AppColors.primaryDark,
                    height: 30,
                    onPress: () {
                      Get.back();
                    })
              ],
            );
          } else {
            AppDialogs.showAppDialogWidget(
              context: context,
              title: 'The order status will be changed to "shipped"'.tr,
              actions: [
                AppButton.normalButton(
                  title: 'Confirm'.tr,
                  shadow: false,
                  width: ScreenSizeUtils.getWidthInPercent(context, 25),
                  height: 30,
                  titleColor: AppColors.white,
                  backgroundColor: AppColors.primaryDark,
                  onPress: () async {
                    Get.back();
                    await ordersController.changeOrderStatus(
                      token: GlobalFunctions.getFcmToken(),
                      status: 'shipped',
                      orderId: order.id!,
                    );
                  },
                ),
                ///////////////
                AppButton.normalButton(
                    title: 'Back'.tr,
                    shadow: false,
                    width: ScreenSizeUtils.getWidthInPercent(context, 25),
                    backgroundColor: AppColors.white,
                    titleColor: AppColors.primaryDark,
                    height: 30,
                    onPress: () {
                      Get.back();
                    })
              ],
            );
          }
        });
  }
}
