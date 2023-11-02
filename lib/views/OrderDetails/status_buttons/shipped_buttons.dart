import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippedButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  ShippedButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderIndex = ordersController.myOrderIndex;
    OrderModel order = ordersController.myOrdersData.data!.data![orderIndex];
    return AppButton.normalButton(
        title: 'Convert To Out For Delivery'.tr,
        height: 40,
        titleSize: 15,
        backgroundColor: AppColors.secondary,
        onPress: () async {
          AppDialogs.showAppDialogWidget(
            context: context,
            title: 'The order status will be changed to "Out For Delivery"'.tr,
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
                    status: 'out_for_delivery',
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
        });
  }
}
