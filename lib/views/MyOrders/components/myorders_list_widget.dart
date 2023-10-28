import 'package:delivery_man_app/controllers/MyOrders/myorders_controller.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/lang_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants/color_constants.dart';

class MyOrderList extends StatelessWidget {
  final MyOrdersController myOrdersController;

  const MyOrderList({super.key, required this.myOrdersController});

  @override
  Widget build(BuildContext context) {
    final orders = myOrdersController.myOrdersData.data!.data!;
    return orders.isEmpty
        ? const Center(child: Text('Data Is Empty'))
        : ListView.builder(
            controller: myOrdersController.scrollController,
            itemCount: orders.length + 1,
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return buildOrderWidget(index, orders);
              } else {
                if (orders.length > 4) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: myOrdersController.noMoreItems
                          ? Text('No More Items'.tr)
                          : const CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
          );
  }

  Widget buildOrderWidget(int index, List<Order> orders) {
    return Container(
        width: double.infinity,
        height: 250,
        color: (index % 2 == 0) ? AppColors.lightGray : AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                  text: '${'Order Summary'.tr} :',
                  color: AppColors.blackDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  maxline: 1),

              ///
              const SizedBox(
                height: 10,
              ),
              ////
              TextWidget(
                  text:
                      '${'Payment Status'.tr} ${orders[index].paymentStatus.toString()}',
                  color: orders[index].paymentStatus.toString() == 'paid'
                      ? Colors.green
                      : Colors.red,
                  fontSize: 11,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                  maxline: 1),
              ////////////////
              const SizedBox(
                height: 8,
              ),
              /////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: '${'Order Status'.tr} :',
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                  /////
                  TextWidget(
                      text: orders[index].orderStatus.toString(),
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                ],
              ),
              ///////////////////////
              const SizedBox(
                height: 8,
              ),
              ///////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: '${'Order Amount'.tr} :',
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                  /////
                  TextWidget(
                      text: orders[index].orderAmountFormatted.toString(),
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                ],
              ),

              ///
              const SizedBox(
                height: 8,
              ),
              ////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: '${'Payment Method'.tr} :',
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                  /////
                  TextWidget(
                      text: orders[index].paymentMethod.toString(),
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                ],
              ),

              ///
              const SizedBox(
                height: 8,
              ),
              ////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: '${'Order unique id'.tr} :',
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                  /////
                  TextWidget(
                      text: orders[index].id.toString(),
                      color: AppColors.blackDark,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                ],
              ),

              ///
              const SizedBox(
                height: 25,
              ),
              ////
              InkWell(
                onTap: () {
                  myOrdersController.orderIndex = index;
                  Get.toNamed(
                    Routes.ordersDetailsPage,
                  );
                },
                child: Align(
                  alignment: GlobalFunctions.getLanLocal() == LangConstants.ara
                      ? Alignment.bottomLeft
                      : Alignment.bottomRight,
                  child: TextWidget(
                      text: 'View Details'.tr,
                      color: AppColors.blackDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                      maxline: 1),
                ),
              ),
            ],
          ),
        ));
  }
}
