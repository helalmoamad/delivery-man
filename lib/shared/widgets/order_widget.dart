// import 'package:delivery_man_app/main.dart';
// import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
// import 'package:delivery_man_app/message_error_log/device_info_util.dart';
// import 'package:delivery_man_app/models/Orders/list_order_model.dart';
// import 'package:delivery_man_app/shared/constants/color_constants.dart';
// import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
// import 'package:delivery_man_app/shared/widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

// class OrderWidget extends StatelessWidget {
//   final List<OrderDataModel> orders;

//   final int index;
//   final void Function() onTapViewDetails;
//   const OrderWidget(
//       {super.key,
//       required this.orders,
//       required this.index,
//       required this.onTapViewDetails});

//   @override
//   Widget build(BuildContext context) {
//      PagesMonitor.addPageToList(page: "OrderWidget");
//     FlutterError.onError = (details) async {
//       FlutterError.presentError(details);
//       final log = await DeviceInfoHelper.createErrorLog(
//           errorType: "Type:${details.exception.runtimeType.toString()} ${details.exceptionAsString().toString()}",
//           lastFourPageVisited: lastFourPageVisited,
//           errorPath: details.stack.toString(),
//           lastApiRequest: '');
//       await errorSender.sendError(log);
//       await Sentry.captureException(details.exception,
//           stackTrace: details.stack);
//     };
//     return Container(
//         width: double.infinity,
//         color: (index % 2 == 0) ? AppColors.lightGray : AppColors.white,
//         child: Padding(
//           padding: const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 28,
//                 width: double.infinity,
//                 color: AppColors.darkGrey,
//                 child: Center(
//                   child: TextWidget(
//                       text: '# ${index + 1}  ${'Order Summary'.tr}',
//                       color: AppColors.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.normal,
//                       textAlign: TextAlign.start,
//                       maxline: 1),
//                 ),
//               ),

//               ///////////////////
//               const SizedBox(
//                 height: 15,
//               ),
//               ////
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: TextWidget(
//                       text:
//                           '${'Payment Status'.tr} : ${GlobalFunctions.paidStatusText(inputText: orders[index].paymentStatus.toString())}',
//                       color:
//                           (orders[index].paymentStatus.toString() == 'paid') ||
//                                   (orders[index].paymentStatus.toString() ==
//                                       'partial_paid')
//                               ? Colors.green
//                               : Colors.red,
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold,
//                       textAlign: TextAlign.center,
//                       maxline: 1),
//                 ),
//               ),
//               ////////////////
//               const SizedBox(
//                 height: 8,
//               ),
//               ///////////////////////////
//               buildOrderFirstDetailsWidget(
//                 title: '${'COD Amount'.tr} :',
//                 isBold: true,
//                 value: orders[index].codAmount == null
//                     ? 'No Data Now'.tr
//                     : orders[index].codAmount.toString() == ''
//                         ? 'No Data Now'.tr
//                         : orders[index].codAmount.toString(),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               /////////////////////////
//               buildOrderFirstDetailsWidget(
//                   title: '${'Order Status'.tr} :',
//                   value: GlobalFunctions.orderStatusText(
//                       inputText: orders[index].orderStatus.toString())),
//               ///////////////////////
//               const SizedBox(
//                 height: 8,
//               ),
//               ///////////////////////////
//               buildOrderFirstDetailsWidget(
//                 title: '${'Order Amount'.tr} :',
//                 value: orders[index].orderAmountFormatted.toString(),
//               ),

//               ///
//               const SizedBox(
//                 height: 8,
//               ),
//               ////
//               buildOrderFirstDetailsWidget(
//                 title: '${'Payment Method'.tr} :',
//                 value: orders[index].paymentMethod.toString(),
//               ),

//               ///
//               const SizedBox(
//                 height: 8,
//               ),
//               ////
//               buildOrderFirstDetailsWidget(
//                 title: '${'Order unique id'.tr} :',
//                 value: orders[index].id.toString(),
//               ),

//               ///
//               const SizedBox(
//                 height: 8,
//               ),
//               ////
//               buildOrderFirstDetailsWidget(
//                 title: '${'Created At'.tr} :',
//                 value: orders[index].createdAt.toString().isEmpty
//                     ? ''
//                     : DateFormat("yyyy-MM-dd HH:mm:ss").format(
//                         DateTime.parse(orders[index].createdAt.toString())
//                             .toLocal()),
//               ),

//               ///
//               const SizedBox(
//                 height: 25,
//               ),
//               ////
//               Container(
//                 height: 40,
//                 width: double.infinity,
//                 color: AppColors.secondary,
//                 child: InkWell(
//                   key: Key("showDetails_${index}"),
//                   onTap: onTapViewDetails,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextWidget(
//                           text: 'View Details'.tr,
//                           color: AppColors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           textAlign: TextAlign.start,
//                           maxline: 1),
//                       //////////////////////////////
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       //////////////////////////////////
//                       const Icon(
//                         Icons.visibility,
//                         color: AppColors.white,
//                       ),
//                       //////////////////////////////////
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }

//   Widget buildOrderFirstDetailsWidget({
//     required String title,
//     required String value,
//     bool isBold = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: TextWidget(
//                 text: title,
//                 color: AppColors.blackDark,
//                 fontSize: 13,
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//                 textAlign: TextAlign.start,
//                 maxline: 1),
//           ),
//           /////
//           Expanded(
//             child: TextWidget(
//                 text: value,
//                 color: AppColors.grey,
//                 fontSize: 13,
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//                 textAlign: TextAlign.end,
//                 maxline: 2),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';

class OrderWidget extends StatelessWidget {
  final List orders;
  final int index;
  final void Function() onTapViewDetails;

  const OrderWidget({
    super.key,
    required this.orders,
    required this.index,
    required this.onTapViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final order = orders[index];

    return GestureDetector(
      onTap: onTapViewDetails,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 90,
              width: 90,
              margin: const EdgeInsets.all(5),
              child: Builder(
                builder: (context) {
                  int count = order.products.length;

                  if (count == 1) {
                    return _buildImage(
                        order.products[0].productDetails.image, 90, 90);
                  } else if (count == 2) {
                    return Row(
                      children: [
                        _buildImage(
                            order.products[0].productDetails.image, 43, 88),
                        _buildImage(
                            order.products[1].productDetails.image, 43, 88),
                      ],
                    );
                  } else if (count == 3) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            _buildImage(
                                order.products[0].productDetails.image, 43, 43),
                            _buildImage(
                                order.products[1].productDetails.image, 43, 43),
                          ],
                        ),
                        _buildImage(
                            order.products[2].productDetails.image, 88, 43),
                      ],
                    );
                  } else if (count == 4) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            _buildImage(
                                order.products[0].productDetails.image, 43, 43),
                            _buildImage(
                                order.products[1].productDetails.image, 43, 43),
                          ],
                        ),
                        Row(
                          children: [
                            _buildImage(
                                order.products[2].productDetails.image, 43, 43),
                            _buildImage(
                                order.products[3].productDetails.image, 43, 43),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          children: [
                            _buildImage(
                                order.products[0].productDetails.image, 43, 43),
                            _buildImage(
                                order.products[1].productDetails.image, 43, 43),
                          ],
                        ),
                        Row(
                          children: [
                            _buildImage(
                                order.products[2].productDetails.image, 43, 43),
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.all(1),
                                  child: Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+${count - 3}',
                                        style: const TextStyle(
                                          backgroundColor: Color.fromARGB(
                                              255, 146, 130, 130),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: '#${index + 1}',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackDark,
                          textAlign: TextAlign.start,
                          maxline: 1,
                        ),TextWidget(
                            text: order.id.toString(),
                            color: const Color.fromARGB(255, 194, 2, 2),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                            maxline: 1,
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: order.paymentStatus == 'paid'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextWidget(
                            text: GlobalFunctions.paidStatusText(
                                inputText: order.paymentStatus),
                            fontSize: 11,
                            color: order.paymentStatus == 'paid'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            maxline: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextWidget(
                            text: GlobalFunctions.orderStatusText(
                                inputText: order.orderStatus.toString()),
                            color: Colors.grey.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                            maxline: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.attach_money,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextWidget(
                            text: (order.orderAmount * order.exchangerate).toString() + order.currencysymbol.toString(),
                            color: Colors.grey.shade800,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                            maxline: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextWidget(
                            text: order.createdAt.toString().isEmpty
                                ? ''
                                : DateFormat("yyyy-MM-dd HH:mm").format(
                                    DateTime.parse(order.createdAt).toLocal()),
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.start,
                            maxline: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: onTapViewDetails,
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.visibility_rounded,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: imageUrl != null && imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage('assets/images/placeholder.png')
                  as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
