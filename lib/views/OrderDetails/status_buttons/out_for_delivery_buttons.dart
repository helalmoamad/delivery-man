import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/custom_text_field.dart';
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
    return GetBuilder<OrdersController>(builder: (_) {
      return ordersController.isStartDeliveryButton
          ? AppButton.normalButton(
              title: 'Start Delivering'.tr,
              height: 40,
              titleSize: 15,
              backgroundColor: AppColors.secondary,
              onPress: () async {
                ordersController.changeDeliveringButton(false);
              })
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppButton.normalButton(
                          title: 'Convert To Delivered'.tr,
                          height: 30,
                          titleSize: 13,
                          backgroundColor:
                              const Color.fromARGB(255, 38, 121, 41),
                          onPress: () async {}),
                    ),
                    /////////////////
                    const SizedBox(
                      width: 5,
                    ),
                    /////////////////
                    Expanded(
                      child: AppButton.normalButton(
                          title: 'Convert To Returned'.tr,
                          height: 30,
                          titleSize: 13,
                          backgroundColor: AppColors.darkGrey,
                          onPress: () async {}),
                    )
                  ],
                ),
                ///////////////////
                Row(
                  children: [
                    Expanded(
                      child: AppButton.normalButton(
                          title: 'Convert To Partial Returned'.tr,
                          height: 30,
                          titleSize: 13,
                          backgroundColor: AppColors.secondary,
                          onPress: () async {}),
                    ),
                    /////////////////
                    const SizedBox(
                      width: 5,
                    ),
                    /////////////////
                    Expanded(
                      child: AppButton.normalButton(
                          title: 'Convert To Failed'.tr,
                          height: 30,
                          titleSize: 13,
                          backgroundColor:
                              const Color.fromARGB(255, 136, 25, 17),
                          onPress: () async {}),
                    )
                  ],
                ),

                // AppButton.normalButton(
                //     title: 'Start Delivering'.tr,
                //     height: 40,
                //     titleSize: 13,
                //     backgroundColor:
                //         // ordersController.isStartDeliveryButton
                //         // ?
                //         AppColors.secondary,
                //     // : AppColors.darkGrey,
                //     onPress: () async {
                //       if (ordersController.isStartDeliveryButton) {
                //         await ordersController.startRecording();
                //         ordersController.changeDeliveringButton(false);
                //       } else {
                //         AppDialogs.showAppDialogWidget(
                //             context: context,
                //             title: 'Enter The Cash Amount'.tr,
                //             actions: [buildDialogAction()]);
                //       }
                //     }),
              ],
            );
    });
  }

  Padding buildDialogAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              textInputType: TextInputType.text,
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
                  await ordersController.stopRecording();
                  // ordersController.changePlayRecordButton(true);
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
