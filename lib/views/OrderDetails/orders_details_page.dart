import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
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
            appBar: customAppBar(
                title: 'Order Details'.tr,
                button: GetBuilder<OrdersController>(builder: (_) {
                  return ordersController.isPlayRecordButton
                      ? AppButton.normalButton(
                          title: ordersController.isRecordPlaying
                              ? 'Stop Record'.tr
                              : 'Play Record'.tr,
                          height: 35,
                          titleSize: 13,
                          backgroundColor: ordersController.isRecordPlaying
                              ? AppColors.darkGrey
                              : AppColors.secondary,
                          onPress: () async {
                            if (ordersController.isRecordPlaying) {
                              await ordersController.stopPlayingRecording();
                              ordersController.changeIsPlaying(false);
                            } else {
                              await ordersController.playRecording();
                              ordersController.changeIsPlaying(true);
                            }
                          })
                      : AppButton.normalButton(
                          title: ordersController.isStartDeliveryButton
                              ? 'Start Delivering'.tr
                              : 'Delivered'.tr,
                          height: 35,
                          titleSize: 13,
                          backgroundColor:
                              ordersController.isStartDeliveryButton
                                  ? AppColors.secondary
                                  : AppColors.darkGrey,
                          onPress: () async {
                            // await ordersController.playRecording();
                            if (ordersController.isStartDeliveryButton) {
                              await ordersController.startRecording();
                              ordersController.changeDeliveringButton(false);
                            } else {
                              AppDialogs.showAppDialogWidget(
                                  context: context,
                                  title: 'Enter The Cash Amount'.tr,
                                  actions: [buildDialogAction()]);
                            }
                          });
                })),
            body: GetBuilder<OrdersController>(builder: (_) {
              return OrderDetails();
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
                  ordersController.changePlayRecordButton(true);
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
