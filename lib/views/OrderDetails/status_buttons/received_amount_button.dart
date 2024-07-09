import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/global_functions/global_functions.dart';
import '../../../shared/widgets/app_buttons.dart';
import '../../../shared/widgets/app_dialogs.dart';
import 'cash_dialog_action.dart';

class ReceivedAmountButton extends StatelessWidget {
  final OrdersController ordersController;
  final GlobalKey<FormState> formKey;
  final TextEditingController cashKey;
  final int orderId;
  const ReceivedAmountButton({
    super.key,
    required this.ordersController,
    required this.formKey,
    required this.cashKey,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton.normalButton(
      title: 'Add Received Amount'.tr,
      height: 40,
      titleSize: 15,
      shadow: false,
      backgroundColor: AppColors.primaryDark,
      onPress: () {
        AppDialogs.showAppDialogWidget(
          context: context,
          title: 'Enter The Cash Amount'.tr,
          actions: [
            buildCashDialogAction(
              cashKey: cashKey,
              formKey: formKey,
              cashAmount: '',
              onPress: () async {
                if (formKey.currentState!.validate()) {
                  Get.back();
                  /////////////////////////////////
                  String token = GlobalFunctions.getToken();
                  await ordersController.changeOrderReceivedAmount(
                    token: token,
                    orderId: orderId,
                    receivedAmount: double.parse(cashKey.text),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
