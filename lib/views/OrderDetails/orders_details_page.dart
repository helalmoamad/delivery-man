import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/circle_indecator_widget.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
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
    if (ordersController.previousRoute == Routes.myOrdersPage) {
      status = ordersController.myOrderStatus;
    } else {
      status = ordersController.orderStatus;
    }
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        if ((ordersController.previousRoute == Routes.myOrdersPage) &&
            (ordersController.myOrderStatus == 'out_for_delivery') &&
            (!ordersController.isStartDeliveryButton)) {
          AppDialogs.showAppDialogWidget(
            context: context,
            title: 'Are you sure to stop recording and leave this page ?'.tr,
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
                  ordersController.changeDeliveringButton(true);
                  await ordersController.stopRecording();
                  ordersController.audioPath = '';
                  Get.close(1);
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
        debugPrint('previousRoute is ${ordersController.previousRoute}');
        return true;
      },
      child: Scaffold(
          appBar: customAppBar(
              title: 'Order Details'.tr,
              button: GetBuilder<OrdersController>(builder: (_) {
                return ordersController.isRecording
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextWidget(
                              text: 'Recording . . .'.tr,
                              color: AppColors.blackDark,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.start,
                              maxline: 1),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.settings_voice_outlined),
                        ],
                      )
                    : Container();
              })),
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
                    height: 100,
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
