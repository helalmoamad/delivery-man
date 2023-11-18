import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/custom_text_field.dart';
import 'package:delivery_man_app/shared/widgets/snackbar_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/color_constants.dart';

class OutForDeliveryButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  OutForDeliveryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderIndex = ordersController.myOrderIndex;
    OrderModel order = ordersController.myOrdersData.data!.data![orderIndex];
    return GetBuilder<OrdersController>(builder: (_) {
      return ordersController.isStartDeliveryButton
          ? AppButton.normalButton(
              title: 'Start Delivering'.tr,
              height: 40,
              titleSize: 15,
              backgroundColor: AppColors.secondary,
              onPress: () async {
                AppDialogs.showAppDialogWidget(
                  context: context,
                  title: 'Audio recording will start'.tr,
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
                        await ordersController.startRecording();
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
              })
          : buildConvertButtons(context, order);
    });
  }

  Widget buildConvertButtons(BuildContext context, OrderModel order) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Expanded(
              child: AppButton.normalButton(
                  title: 'Convert To Delivered'.tr,
                  height: 40,
                  titleSize: 13,
                  backgroundColor: const Color.fromARGB(255, 38, 121, 41),
                  onPress: () {
                    AppDialogs.showAppDialogWidget(
                        context: context,
                        title: 'Enter The Cash Amount'.tr,
                        actions: [buildDialogAction(order, 'delivered')]);
                  }),
            ),
            /////////////////
            const SizedBox(
              width: 5,
            ),
            /////////////////
            Expanded(
              child: AppButton.normalButton(
                  title: 'Convert To Returned'.tr,
                  height: 40,
                  titleSize: 13,
                  backgroundColor: AppColors.darkGrey,
                  onPress: () {
                    AppDialogs.showAppDialogWidget(
                      context: context,
                      title:
                          'The order status will be changed to "Returned"'.tr,
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
                            await ordersController
                                .stopRecording()
                                .then((value) async {
                              await ordersController.changeOrderStatus(
                                  token: GlobalFunctions.getFcmToken(),
                                  status: 'returned',
                                  orderId: order.id!,
                                  file: ordersController.audioPath);
                            });
                          },
                        ),
                        ///////////////
                        AppButton.normalButton(
                            title: 'Back'.tr,
                            shadow: false,
                            width:
                                ScreenSizeUtils.getWidthInPercent(context, 25),
                            backgroundColor: AppColors.white,
                            titleColor: AppColors.primaryDark,
                            height: 30,
                            onPress: () {
                              Get.back();
                            })
                      ],
                    );
                  }),
            )
          ],
        ),
        ///////////////////
        Row(
          children: [
            Expanded(
              child: AppButton.normalButton(
                  title: 'Convert To Partial Returned'.tr,
                  height: 40,
                  titleSize: 13,
                  backgroundColor: AppColors.secondary,
                  onPress: () {
                    if (ordersController.returnedProductsList.isEmpty) {
                      SnackBarWidgets.showFailureSnackBar(
                          'Add the returned products'.tr,
                          'You have to add the returned products first'.tr,
                          seconds: 4);
                    } else {
                      AppDialogs.showAppDialogWidget(
                          context: context,
                          title: 'Enter The Cash Amount'.tr,
                          actions: [
                            buildDialogAction(order, 'partial_return')
                          ]);
                    }
                  }),
            ),
            /////////////////
            const SizedBox(
              width: 5,
            ),
            /////////////////
            Expanded(
              child: AppButton.normalButton(
                  title: 'Convert To Failed'.tr,
                  height: 40,
                  titleSize: 13,
                  backgroundColor: const Color.fromARGB(255, 136, 25, 17),
                  onPress: () {
                    AppDialogs.showAppDialogWidget(
                      context: context,
                      title: 'The order status will be changed to "Failed"'.tr,
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
                            await ordersController
                                .stopRecording()
                                .then((value) async {
                              await ordersController.changeOrderStatus(
                                  token: GlobalFunctions.getFcmToken(),
                                  status: 'failed',
                                  orderId: order.id!,
                                  file: ordersController.audioPath);
                            });
                          },
                        ),
                        ///////////////
                        AppButton.normalButton(
                            title: 'Back'.tr,
                            shadow: false,
                            width:
                                ScreenSizeUtils.getWidthInPercent(context, 25),
                            backgroundColor: AppColors.white,
                            titleColor: AppColors.primaryDark,
                            height: 30,
                            onPress: () {
                              Get.back();
                            })
                      ],
                    );
                  }),
            )
          ],
        ),
      ],
    );
  }

  Padding buildDialogAction(OrderModel order, String orderStatus) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              textInputType: TextInputType.number,
              controller: cashKey,
              hintText: '',
              labelText: 'Cash Amount'.tr,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Cash Amount should not be empty'.tr;
                }
              },
              prefixIcon: null,
              suffixIcon: null,
            ),
            /////////////////////
            const SizedBox(
              height: 30,
            ),
            /////////////////////
            AppButton.normalButton(
              title: 'Confirm The Process'.tr,
              shadow: false,
              height: 35,
              titleColor: AppColors.white,
              backgroundColor: AppColors.primaryDark,
              onPress: () async {
                if (formKey.currentState!.validate()) {
                  Get.back();
                  await ordersController.stopRecording().then((value) async {
                    await ordersController.changeOrderStatus(
                        token: GlobalFunctions.getFcmToken(),
                        status: orderStatus,
                        orderId: order.id!,
                        returnedProducts: orderStatus == 'partial_return'
                            ? ordersController.returnedProductsList
                            : null,
                        amount: int.parse(cashKey.text),
                        file: ordersController.audioPath);
                  });
                }
              },
            ),
            /////////////////////
            const SizedBox(
              height: 20,
            ),
            /////////////////////
          ],
        ),
      ),
    );
  }
}
