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

class OutForReturnButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  final TextEditingController noteKey = TextEditingController();
  OutForReturnButtons({super.key});
  final noteFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    int orderId = ordersController.myOrderIdForDetails;
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
                    title: 'Convert To Out For Return'.tr,
                    height: 40,
                    titleSize: 15,
                    shadow: false,
                    backgroundColor: AppColors.darkGrey,
                    onPress: () async {
                      await ordersController.changeOrderStatus(
                        token: GlobalFunctions.getToken(),
                        status: OrderStatuses.returnedToDeliveryCenter,
                        orderId: order.id!,
                        note: noteKey.text,
                      );
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
                  GlobalFunctions.getUserId() != order.assignToUserId
            ? const SizedBox(
                height: 10,
              )
            :
            ////////////////////////
            AppButton.normalButton(
                title: 'UnAssign Order'.tr,
                height: 40,
                titleSize: 15,
                backgroundColor: AppColors.secondary,
                onPress: () async {
                  AppDialogs.showAppDialogWidget(
                    context: context,
                    title: 'Enter The Note'.tr,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: noteFormKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                textInputType: TextInputType.text,
                                controller: noteKey,
                                hintText: '',
                                labelText: 'Note'.tr,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'note should not be empty'.tr;
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
                                  Get.back();
                                  await ordersController
                                      .unAssignOrderToMe(
                                    token: GlobalFunctions.getToken(),
                                    orderId: order.id!,
                                    note: noteKey.text,
                                    confirm: null,
                                  )
                                      .then(
                                    (value) {
                                      if (ordersController
                                              .unAssignOrderToMeData!
                                              .data!
                                              .otherAssignedCount! >
                                          0) {
                                        AppDialogs.showConfirmationDialog(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          title: ordersController
                                                  .unAssignOrderToMeData!
                                                  .data!
                                                  .notificationMessage ??
                                              '',
                                          onConfirm: () async {
                                            Get.back();
                                            /////////////////////
                                            ordersController.unAssignOrderToMe(
                                              token: GlobalFunctions.getToken(),
                                              orderId: order.id!,
                                              note: noteKey.text,
                                              confirm: true,
                                            );
                                          },
                                        );
                                      }
                                    },
                                  );
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
                      ),
                    ],
                  );
                },
              )

                  // ReceivedAmountButton(
                  //   ordersController: ordersController,
                  //   formKey: formKey,
                  //   cashKey: cashKey,
                  //   orderId: order.id!,
                  // )
                ],
              );
      },
    );
  }

}
