import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../shared/constants/order_statuses.dart';

class InDeliveryCenterButtons extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final formKey = GlobalKey<FormState>();
  final noteFormKey = GlobalKey<FormState>();
  final TextEditingController cashKey = TextEditingController();
  final TextEditingController noteKey = TextEditingController();
  InDeliveryCenterButtons({super.key});

  @override
  Widget build(BuildContext context) {
    int orderId;
    final OrderDataModel order;
    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      orderId = int.parse(GlobalFunctions.getOrderId() ?? '-1');
      order = ordersController.orderDetails!;
    } else {
      if (ordersController.previousRoute == Routes.myOrdersPage) {
        orderId = ordersController.myOrderIdForDetails;
        order = ordersController.myOrdersData!.data!.data!
            .firstWhere((element) => element.id! == orderId);
      } else {
        orderId = ordersController.orderIdForDetails;
        order = ordersController.ordersData!.data!.data!
            .firstWhere((element) => element.id! == orderId);
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.normalButton(
          key1: const Key('assignButton'),
          title: GlobalFunctions.getUserId() != order.assignToUserId
              ? 'Assign To Me'.tr
              : 'Convert To Out For Delivery'.tr,
          height: 40,
          titleSize: 15,
          backgroundColor: GlobalFunctions.getUserId() != order.assignToUserId
              ? AppColors.secondary
              : AppColors.darkGrey,
          onPress: () async {
            if (GlobalFunctions.getUserId() != order.assignToUserId) {
              AppDialogs.showConfirmationDialog(
                context: context,
                title: 'The order  will be assigned to you'.tr,
                onConfirm: () async {
                  Get.back();
                  await ordersController
                      .assignOrderToMe(
                    token: GlobalFunctions.getToken(),
                    orderId: order.id!,
                    confirm: null,
                  )
                      .then(
                    (value) {
                      if (ordersController
                              .assignOrderToMeData.data!.otherUnassignedCount! >
                          0) {
                        AppDialogs.showConfirmationDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          title: ordersController.assignOrderToMeData.data!
                                  .notificationMessage ??
                              '',
                          onConfirm: () async {
                            Get.back();
                            /////////////////////
                            ordersController.assignOrderToMe(
                              token: GlobalFunctions.getToken(),
                              orderId: order.id!,
                              confirm: true,
                            );
                          },
                        );
                      }
                    },
                  );
                },
              );
            } else {
              AppDialogs.showConfirmationDialog(
                context: context,
                title:
                    'The order status will be changed to "Out For Delivery"'.tr,
                // 'The order status will be changed to "shipped"'.tr,
                onConfirm: () async {
                  Get.back();
                  await ordersController.changeOrderStatus(
                    token: GlobalFunctions.getToken(),
                    status: OrderStatuses.outForDelivery,
                    // OrderStatuses.outForDelivery,
                    orderId: order.id!,
                  );
                },
              );
            }
          },
        ),
        //////////////////////
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
                                    return 'Note_should_not_be_empty'.tr;
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
                                  if(noteFormKey.currentState!.validate()){
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
                      ),
                    ],
                  );
                },
              )
      ],
    );
  }
}
