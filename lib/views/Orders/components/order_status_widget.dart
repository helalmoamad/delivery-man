import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import '../../../controllers/Orders/orders_controller.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class OrderStatusWidget extends StatelessWidget {
  final OrdersController ordersController;
  const OrderStatusWidget({
    super.key,
    required this.ordersController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SizedBox(
        height: 30,
        child: ListView.separated(
          itemCount: ordersController.orderStatusData.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                ordersController.chooseOrderStatus(
                    status: ordersController.orderStatusData[index].toString(),
                    index: index);

                debugPrint(ordersController.orderStatus);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: GlobalFunctions.orderStatusText(
                          inputText: ordersController.orderStatusData[index]
                              .toString()),
                      color: AppColors.blackDark,
                      fontSize: 15,
                      fontWeight: index == ordersController.selectedOrderStatus
                          ? FontWeight.bold
                          : FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),

                  ///////////
                  index == ordersController.selectedOrderStatus
                      ? Container(
                          width: 80,
                          height: 2,
                          color: AppColors.primaryDark,
                        )
                      : Container()
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 20,
            );
          },
        ),
      ),
    );
  }
}
