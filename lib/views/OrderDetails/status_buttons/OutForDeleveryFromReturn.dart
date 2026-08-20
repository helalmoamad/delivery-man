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
import '../../../shared/widgets/custom_text_field.dart';

class OutForDeleveryFromReturnButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  final TextEditingController noteKey = TextEditingController();
  OutForDeleveryFromReturnButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderId = ordersController.myOrderIdForDetails;
    int? originalLocId = ordersController.orginalLocationId;
    OrderDataModel order;
    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      order = ordersController.orderDetails!;
    } else {
      order = ordersController.myOrdersData!.data!.data!
          .firstWhere((element) => element.id! == orderId);
    }

    return GetBuilder<OrdersController>(
      builder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppButton.normalButton(
              title: 'Convert To Return To Location'.tr,
              height: 40,
              titleSize: 15,
              shadow: false,
              backgroundColor: AppColors.darkGrey,
              onPress: () async {
                if (ordersController.orginalLocationId == null) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: const Color.fromARGB(255, 200, 5, 5),
                        content: Text(
                          "Please choose a location".tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  );
                } else {
                  await ordersController.changeOrderStatus(
                    token: GlobalFunctions.getToken(),
                    status: OrderStatuses.returnedToLocation,
                    orderId: order.id!,
                    originalLocId: ordersController.orginalLocationId!,
                    note: noteKey.text,
                  );
                }
              },
              // onPress: () {
              //   AppDialogs.showAppDialogWidget(
              //     context: context,
              //     title: 'Enter The Note'.tr,
              //     actions: [
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 20),
              //         child: Form(
              //           key: formKey,
              //           child: Column(
              //             children: [
              //               CustomTextField(
              //                 textInputType: TextInputType.text,
              //                 controller: noteKey,
              //                 hintText: '',
              //                 labelText: 'Note'.tr,
              //                 validator: (value) {
              //                   if (value.isEmpty) {
              //                     return 'note should not be empty'.tr;
              //                   }
              //                 },
              //                 prefixIcon: null,
              //                 suffixIcon: null,
              //               ),
              //               /////////////////////
              //               const SizedBox(
              //                 height: 30,
              //               ),
              //               /////////////////////
              //               AppButton.normalButton(
              //                 title: 'Confirm The Process'.tr,
              //                 shadow: false,
              //                 height: 35,
              //                 titleColor: AppColors.white,
              //                 backgroundColor: AppColors.primaryDark,
              //                 onPress: () async {
              //                   Get.back();
              //                   await ordersController.changeOrderStatus(
              //                     token: GlobalFunctions.getToken(),
              //                     status: OrderStatuses.returnedToDeliveryCenter,
              //                     orderId: order.id!,
              //                     note: noteKey.text,
              //                   );
              //                 },
              //               ),
              //               /////////////////////
              //               const SizedBox(
              //                 height: 20,
              //               ),
              //               /////////////////////
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   );
              // },
            ),

            // ReceivedAmountButton(
            //   ordersController: ordersController,
            //   formKey: formKey,
            //   cashKey: cashKey,
            //   orderId: order.id!,
            // )
          ],
        );
        // return const SizedBox();
      },
    );
  }
}
