import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/snackbar_widgets.dart';
import 'package:delivery_man_app/views/OrderDetails/status_buttons/cash_dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/color_constants.dart';
import '../../../shared/constants/order_statuses.dart';

class OutForDeliveryButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  OutForDeliveryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderId = ordersController.myOrderIdForDetails;
    OrderDataModel order = ordersController.myOrdersData!.data!.data!
        .firstWhere((element) => element.id! == orderId);
    return GetBuilder<OrdersController>(builder: (_) {
      return ordersController.isStartDeliveryButton
          ? AppButton.normalButton(
              title: 'Start Delivering'.tr,
              height: 40,
              titleSize: 15,
              backgroundColor: AppColors.secondary,
              onPress: () async {
                AppDialogs.showConfirmationDialog(
                  context: context,
                  title: 'Audio recording will start'.tr,
                  onConfirm: () async {
                    Get.back();
                    await ordersController.startRecording(
                      orderId: order.id.toString(),
                    );
                  },
                );
              },
            )
          : buildConvertButtons(context, order);
    });
  }

  Widget buildConvertButtons(BuildContext context, OrderDataModel order) {
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
                      actions: [
                        buildCashDialogAction(
                          cashKey: cashKey,
                          formKey: formKey,
                          onPress: () async {
                            if (formKey.currentState!.validate()) {
                              Get.back();
                              await ordersController.stopRecording().then(
                                (value) async {
                                  await ordersController.changeOrderStatus(
                                    token: GlobalFunctions.getToken(),
                                    status: OrderStatuses.delivered,
                                    orderId: order.id!,
                                    returnedProducts: null,
                                    amount: double.parse(cashKey.text),
                                    file: ordersController.audioPath,
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
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
                  AppDialogs.showConfirmationDialog(
                    context: context,
                    title: 'The order status will be changed to "Returned"'.tr,
                    onConfirm: () async {
                      Get.back();
                      await ordersController.stopRecording().then(
                        (value) async {
                          await ordersController.changeOrderStatus(
                              token: GlobalFunctions.getToken(),
                              status: OrderStatuses.returned,
                              orderId: order.id!,
                              file: ordersController.audioPath);
                        },
                      );
                    },
                  );
                },
              ),
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
                            buildCashDialogAction(
                                cashKey: cashKey,
                                formKey: formKey,
                                onPress: () async {
                                  if (formKey.currentState!.validate()) {
                                    Get.back();
                                    await ordersController.stopRecording().then(
                                      (value) async {
                                        await ordersController
                                            .changeOrderStatus(
                                          token: GlobalFunctions.getToken(),
                                          status: OrderStatuses.partialReturn,
                                          orderId: order.id!,
                                          returnedProducts: ordersController
                                              .returnedProductsList,
                                          amount: double.parse(cashKey.text),
                                          file: ordersController.audioPath,
                                        );
                                      },
                                    );
                                  }
                                })
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
                    AppDialogs.showConfirmationDialog(
                      context: context,
                      title: 'The order status will be changed to "Failed"'.tr,
                      onConfirm: () async {
                        Get.back();
                        await ordersController
                            .stopRecording()
                            .then((value) async {
                          await ordersController.changeOrderStatus(
                              token: GlobalFunctions.getToken(),
                              status: OrderStatuses.failed,
                              orderId: order.id!,
                              file: ordersController.audioPath);
                        });
                      },
                    );
                  }),
            )
          ],
        ),
      ],
    );
  }
}
