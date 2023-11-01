import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderWidget extends StatelessWidget {
  final List<Order> orders;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextWidget(
                    text:
                        '${'Payment Status'.tr} ${orders[index].paymentStatus.toString()}',
                    color: orders[index].paymentStatus.toString() == 'paid'
                        ? Colors.green
                        : Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.start,
                    maxline: 1),
              ),
              ////////////////
              const SizedBox(
                height: 8,
              ),
              /////////////////////////
              buildOrderFirstDetailsWidget('${'Order Status'.tr} :',
                  orders[index].orderStatus.toString()),
              ///////////////////////
              const SizedBox(
                height: 8,
              ),
              ///////////////////////////
              buildOrderFirstDetailsWidget(
                '${'Order Amount'.tr} :',
                orders[index].orderAmountFormatted.toString(),
              ),

              ///
              const SizedBox(
                height: 8,
              ),
              ////
              buildOrderFirstDetailsWidget(
                '${'Payment Method'.tr} :',
                orders[index].paymentMethod.toString(),
              ),

              ///
              const SizedBox(
                height: 8,
              ),
              ////
              buildOrderFirstDetailsWidget(
                '${'Order unique id'.tr} :',
                orders[index].id.toString(),
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

  Widget buildOrderFirstDetailsWidget(String title, String value) {
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
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
                maxline: 1),
          ),
          /////
          Expanded(
            child: TextWidget(
                text: value,
                color: AppColors.grey,
                fontSize: 13,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.end,
                maxline: 2),
          ),
        ],
      ),
    );
  }
}
