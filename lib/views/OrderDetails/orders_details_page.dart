import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/widgets/app_dialogs.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'components/order_details.dart';

class OrdersDetailsPage extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  OrdersDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar:
                customAppBar(title: 'Order Details'.tr, button: Container()),
            body: GetBuilder<OrdersController>(builder: (_) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  OrderDetails(),
                  //////////////////////
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
                              inputText: 'ready_to_shipping'),
                        )
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
                        ),
                  ),
                ],
              );
            })));
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
