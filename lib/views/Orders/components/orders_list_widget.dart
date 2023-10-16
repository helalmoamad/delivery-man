import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../../../controllers/Orders/orders_controller.dart';
import '../../../shared/constants/color_constants.dart';

class OrderList extends StatelessWidget {
  final OrdersController ordersController;
  const OrderList({super.key, required this.ordersController});

  @override
  Widget build(BuildContext context) {
    final orders = ordersController.ordersData.data!.orders!;
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Container(
            width: double.infinity,
            height: 160,
            color: (index % 2 == 0) ? AppColors.lightGray : AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                      text: 'Order Summary :',
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
                          'Payment Status ${orders[index].paymentStatus.toString()}',
                      color: orders[index].paymentStatus.toString() == 'paid'
                          ? Colors.green
                          : Colors.red,
                      fontSize: 10,
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
                      const TextWidget(
                          text: 'Order Status :',
                          color: AppColors.blackDark,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                          maxline: 1),
                      /////
                      TextWidget(
                          text: orders[index].orderStatus.toString(),
                          color: AppColors.blackDark,
                          fontSize: 12,
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
                      const TextWidget(
                          text: 'Order Amount :',
                          color: AppColors.blackDark,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                          maxline: 1),
                      /////
                      TextWidget(
                          text: orders[index].orderAmount.toString(),
                          color: AppColors.blackDark,
                          fontSize: 12,
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
                      const TextWidget(
                          text: 'Payment Method :',
                          color: AppColors.blackDark,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                          maxline: 1),
                      /////
                      TextWidget(
                          text: orders[index].paymentMethod.toString(),
                          color: AppColors.blackDark,
                          fontSize: 12,
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
                      const TextWidget(
                          text: 'Order unique id :',
                          color: AppColors.blackDark,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                          maxline: 1),
                      /////
                      TextWidget(
                          text: orders[index].id.toString(),
                          color: AppColors.blackDark,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.start,
                          maxline: 1),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}
