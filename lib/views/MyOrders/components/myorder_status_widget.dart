import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class MyOrderStatusWidget extends StatelessWidget {
  final OrdersController ordersController;
  const MyOrderStatusWidget({
    super.key,
    required this.ordersController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
          itemCount: ordersController.orderStatusData.length - 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                ordersController.chooseMyOrderStatus(
                    status:
                        ordersController.orderStatusData[index + 2].toString(),
                    index: index);

                debugPrint(ordersController.myOrderStatus);
              },
              child: SizedBox(
                height: 35,
                width: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                        text: GlobalFunctions.orderStatusText(
                            inputText: ordersController
                                .orderStatusData[index + 2]
                                .toString()),
                        color: AppColors.blackDark,
                        fontSize: 15,
                        fontWeight:
                            index == ordersController.selectedMyOrderStatus
                                ? FontWeight.bold
                                : FontWeight.normal,
                        textAlign: TextAlign.center,
                        maxline: 1),

                    ///////////
                    index == ordersController.selectedMyOrderStatus
                        ? Container(
                            height: 2,
                            color: AppColors.primaryDark,
                          )
                        : Container()
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 0,
            );
          },
        ),
      ),
    );
  }
}
