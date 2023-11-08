import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/RequestInfo/request_info_model.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreInfoPage extends StatelessWidget {
  MoreInfoPage({super.key});
  final OrdersController ordersController = Get.find<OrdersController>();
  @override
  Widget build(BuildContext context) {
    final data = GlobalFunctions.getRequestsInfo();
    int index = ordersController.moreDeveloperInfoIndex;
    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(title: 'More Info'.tr, button: Container()),
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryDark)),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildInfoText(
                            data[index],
                          )
                        ],
                      ),
                    ),
                  ),
                ))));
  }

  Widget buildInfoText(RequestInfoModel data) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontFamily: 'Montserrat',
        ),
        children: <TextSpan>[
          const TextSpan(
              text: 'Url : ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: '${data.url}\n\n',
          ),
          const TextSpan(
              text: 'Request : ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: '${data.requestType}\n\n',
          ),
          const TextSpan(
              text: 'Token : ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: '${data.token}\n\n',
          ),
          const TextSpan(
              text: 'Headers : ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: '${data.header}\n\n',
          ),
          const TextSpan(
              text: 'Body : ', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: '${data.body}\n\n',
          ),
          const TextSpan(
              text: 'Response : ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
            text: data.response,
          ),
        ],
      ),
    );
  }
}
