import 'package:delivery_man_app/controllers/MyOrders/myorders_controller.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class MyOrderStatusWidget extends StatelessWidget {
  final MyOrdersController myOrdersController;
  const MyOrderStatusWidget({
    super.key,
    required this.myOrdersController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SizedBox(
        height: 30,
        child: ListView.separated(
          itemCount: myOrdersController.orderStatusData.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                myOrdersController.chooseOrderStatus(
                    status:
                        myOrdersController.orderStatusData[index].toString(),
                    index: index);

                debugPrint(myOrdersController.orderStatus);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: GlobalFunctions.orderStatusText(
                          inputText: myOrdersController.orderStatusData[index]
                              .toString()),
                      color: AppColors.blackDark,
                      fontSize: 15,
                      fontWeight:
                          index == myOrdersController.selectedOrderStatus
                              ? FontWeight.bold
                              : FontWeight.normal,
                      textAlign: TextAlign.start,
                      maxline: 1),

                  ///////////
                  index == myOrdersController.selectedOrderStatus
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
