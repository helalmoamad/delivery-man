import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatelessWidget {
  final List<OrderDataModel> orders;

  final int index;
  final void Function() onTapViewDetails;
  const OrderWidget(
      {super.key,
      required this.orders,
      required this.index,
      required this.onTapViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: (index % 2 == 0) ? AppColors.lightGray : AppColors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 28,
                width: double.infinity,
                color: AppColors.darkGrey,
                child: Center(
                  child: TextWidget(
                      text: '# ${index + 1}  ${'Order Summary'.tr}',
                      color: AppColors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),
                ),
              ),

              ///////////////////
              const SizedBox(
                height: 15,
              ),
              ////
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextWidget(
                      text:
                          '${'Payment Status'.tr} : ${GlobalFunctions.paidStatusText(inputText: orders[index].paymentStatus.toString())}',
                      color:
                          (orders[index].paymentStatus.toString() == 'paid') ||
                                  (orders[index].paymentStatus.toString() ==
                                      'partial_paid')
                              ? Colors.green
                              : Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                      maxline: 1),
                ),
              ),
              ////////////////
              const SizedBox(
                height: 8,
              ),
              ///////////////////////////
              buildOrderFirstDetailsWidget(
                title: '${'COD Amount'.tr} :',
                isBold: true,
                value: orders[index].codAmount == null
                    ? 'No Data Now'.tr
                    : orders[index].codAmount.toString() == ''
                        ? 'No Data Now'.tr
                        : orders[index].codAmount.toString(),
              ),
              const SizedBox(
                height: 8,
              ),
              /////////////////////////
              buildOrderFirstDetailsWidget(
                  title: '${'Order Status'.tr} :',
                  value: GlobalFunctions.orderStatusText(
                      inputText: orders[index].orderStatus.toString())),
              ///////////////////////
              const SizedBox(
                height: 8,
              ),
              ///////////////////////////
              buildOrderFirstDetailsWidget(
                title: '${'Order Amount'.tr} :',
                value: orders[index].orderAmountFormatted.toString(),
              ),

              ///
              const SizedBox(
                height: 8,
              ),
              ////
              buildOrderFirstDetailsWidget(
                title: '${'Payment Method'.tr} :',
                value: orders[index].paymentMethod.toString(),
              ),

              ///
              const SizedBox(
                height: 8,
              ),
              ////
              buildOrderFirstDetailsWidget(
                title: '${'Order unique id'.tr} :',
                value: orders[index].id.toString(),
              ),

              ///
              const SizedBox(
                height: 8,
              ),
              ////
              buildOrderFirstDetailsWidget(
                title: '${'Created At'.tr} :',
                value: orders[index].createdAt.toString().isEmpty
                    ? ''
                    : DateFormat("yyyy-MM-dd HH:mm:ss").format(
                        DateTime.parse(orders[index].createdAt.toString())
                            .toLocal()),
              ),

              ///
              const SizedBox(
                height: 25,
              ),
              ////
              Container(
                height: 40,
                width: double.infinity,
                color: AppColors.secondary,
                child: InkWell(
                  key: Key("showDetails_${orders[index].id}"),
                  onTap: onTapViewDetails,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                          text: 'View Details'.tr,
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                          maxline: 1),
                      //////////////////////////////
                      const SizedBox(
                        width: 10,
                      ),
                      //////////////////////////////////
                      const Icon(
                        Icons.visibility,
                        color: AppColors.white,
                      ),
                      //////////////////////////////////
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildOrderFirstDetailsWidget({
    required String title,
    required String value,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextWidget(
                text: title,
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                textAlign: TextAlign.start,
                maxline: 1),
          ),
          /////
          Expanded(
            child: TextWidget(
                text: value,
                color: AppColors.grey,
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                textAlign: TextAlign.end,
                maxline: 2),
          ),
        ],
      ),
    );
  }
}
