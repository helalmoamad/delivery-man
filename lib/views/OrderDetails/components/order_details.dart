import 'package:app_settings/app_settings.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/list_ex.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:delivery_man_app/views/OrderDetails/components/product_widget.dart';
import 'package:delivery_man_app/views/OrderDetails/components/title_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/Orders/list_order_model.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/constants/order_statuses.dart';
import '../../../shared/global_functions/global_functions.dart';
import 'order_details_widget.dart';

class OrderDetails extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();

  OrderDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "OrderDetails");
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      final log = await DeviceInfoHelper.createErrorLog(
          errorType: "Flutter Error",
          lastFourPageVisited: lastFourPageVisited,
          errorPath: lastFourPageVisited.last ?? "",
          lastApiRequest: '');
      await errorSender.sendError(log);
      await Sentry.captureException(details.exception,
          stackTrace: details.stack);
    };
    int orderId;
    String status;
    bool isForMyOrder;
    final OrderDataModel order;
    debugPrint(
        '///////isFromNotifiForNewOrder///${GlobalFunctions.getIsFromNotifiForNewOrder()}');
    if (GlobalFunctions.getIsFromNotifiForNewOrder()) {
      isForMyOrder = false;
      orderId = int.parse(GlobalFunctions.getOrderId() ?? '-1');
      order = ordersController.orderDetails!;
      status = (GetIt.I<PrefsRepository>().myParentOrderIdForChat != "" &&
              GetIt.I<PrefsRepository>().myParentOrderIdForChat != null)
          ? OrderStatuses.returnedToDeliveryCenter
          : (GetIt.I<PrefsRepository>().myOrderIdForChat != "" &&
                  GetIt.I<PrefsRepository>().myOrderIdForChat != null)
              ? OrderStatuses.outForDelivery
              : OrderStatuses.inDeliveryCenter;
    } else {
      if (ordersController.previousRoute == Routes.myOrdersPage) {
        isForMyOrder = true;
        orderId = ordersController.myOrderIdForDetails;
        order = ordersController.myOrdersData!.data!.data!
            .firstWhere((element) => element.id! == orderId);
        status = ordersController.myOrderStatus;
      } else {
        isForMyOrder = false;
        orderId = ordersController.orderIdForDetails;
        order = ordersController.ordersData!.data!.data!
            .firstWhere((element) => element.id! == orderId);
        status = ordersController.orderStatus;
      }
    }
    return RefreshIndicator(
      onRefresh: () async {
        String token = GlobalFunctions.getToken();
        ///////////////////////////////////////////
        await ordersController.getOrderDetailsData(
          token: token,
          orderId: orderId,
          isForMyOrder: isForMyOrder,
        );
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              right: 5,
              left: 5,
              top: 0,
              bottom: (status == OrderStatuses.inDeliveryCenter ||
                      // status == OrderStatuses.shipped ||
                      status == OrderStatuses.outForDelivery)
                  ? 101
                  : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleSectionWidget(
                title: 'More Order Info'.tr,
                index: '',
              ),
              ///////////////
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5),
              //   child: Container(
              //     height: 3,
              //     width: double.infinity,
              //     color: AppColors.primaryDark,
              //   ),
              // ),
              // ////////////////////////////////
              moreOrderInfoSection(order),
              ///////////////
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5),
              //   child: Container(
              //     height: 3,
              //     width: double.infinity,
              //     color: AppColors.primaryDark,
              //   ),
              // ),
              if (order.orderStatus == OrderStatuses.returnedToDeliveryCenter || order.orderStatus == OrderStatuses.onHold)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(top: 2, bottom: 5),
                      child: TitleSectionWidget(
                        title: 'Avilable returned locations'.tr,
                        index: '',
                      ),
                    ),
                    availableReturnedLocations(order),
                  ],
                ),
              //////////////////////////////////
              GetBuilder<OrdersController>(
                builder: (_) {
                  return TitleSectionWidget(
                    title: 'Order Products'.tr,
                    index: '',
                    widget: (status == OrderStatuses.outForDelivery &&
                            !ordersController.isStartDeliveryButton)
                        ? TextWidget(
                            text:
                                '${'Returned Products'.tr} : ${ordersController.returnedProductsList.length}',
                            color: AppColors.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            textAlign: TextAlign.center,
                            maxline: 2)
                        : Container(),
                  );
                },
              ),

              // ////////////////////////////////
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5),
              //   child: Container(
              //     height: 3,
              //     width: double.infinity,
              //     color: AppColors.primaryDark,
              //   ),
              // ),
              //////////////////////////////////
              GetBuilder<OrdersController>(
                builder: (_) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.products!.length,
                    itemBuilder: (context, index) {
                      return buildProductsSection(
                          order, order.products, index, status);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox();
                    },
                  );
                },
              ),
              ////////////////////////////////////////
              order.returnedProducts!.isEmpty
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        height: 3,
                        width: double.infinity,
                        color: AppColors.primaryDark,
                      ),
                    ),
              // ////////////////////////////////

              order.returnedProducts!.isEmpty
                  ? Container()
                  : TitleSectionWidget(
                      title: 'Returned Products'.tr,
                      index: '',
                    ),
              ///////////////
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5),
              //   child: Container(
              //     height: 3,
              //     width: double.infinity,
              //     color: AppColors.primaryDark,
              //   ),
              // ),
              // ////////////////////////////////
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.returnedProducts!.length,
                itemBuilder: (context, index) {
                  return buildProductsSection(
                      order, order.returnedProducts, index, status);
                },
                separatorBuilder: (context, index) {
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  //mainnnn
  // Widget buildProductsSection(OrderDataModel order,
  //     List<ProductModel>? products, int productsIndex, String status) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       ////////////////////////////////
  //       TitleSectionWidget(
  //         title: 'Product'.tr,
  //         index: '#${productsIndex + 1}  ',
  //         widget: (status == OrderStatuses.outForDelivery &&
  //                 !ordersController.isStartDeliveryButton)
  //             ? AppButton.normalButton(
  //                 title: ordersController
  //                         .isProductInReturnedProducts(products![productsIndex])
  //                     ? 'Remove from returned'.tr
  //                     : 'Add to returned'.tr,
  //                 height: 35,
  //                 width: 100,
  //                 titleSize: 13,
  //                 backgroundColor: ordersController
  //                         .isProductInReturnedProducts(products[productsIndex])
  //                     ? AppColors.primaryDark
  //                     : AppColors.secondary,
  //                 onPress: () {
  //                   ordersController
  //                       .addReturnedProducts(products[productsIndex]);
  //                 })
  //             : null,
  //       ),
  //       productsSection(products, productsIndex),
  //       ////////////////////////////
  //       TitleSectionWidget(
  //         title: 'General Info'.tr,
  //         index: '',
  //       ),
  //       /////////////////////
  //       generalInfoSection(products, productsIndex),
  //     ],
  //   );
  // }

Widget buildProductsSection(
    OrderDataModel order, List<ProductModel>? products, int productsIndex, String status) {
  final product = products![productsIndex];
  final details = product.productDetails!;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 6,
    shadowColor: Colors.grey.withOpacity(0.3),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    child: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF9F9F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
              image: DecorationImage(
  image: details.images.isNullOrEmpty
      ? (details.image != null && details.image!.isNotEmpty
          ? NetworkImage(details.image!)
          : const AssetImage('assets/pictures/image.jpg') as ImageProvider)
      : NetworkImage(details.images![0].toString()),
  fit: BoxFit.cover,
),

            ),
          ),
          const SizedBox(width: 14),

          // المعلومات العامة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.name.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // المعلومات التفصيلية
                infoRowWithIcon(Icons.price_check, 'Price'.tr, (details.price * ordersController.currentOrder!.exchangerate).toStringAsFixed(0) + ordersController.currentOrder!.currencysymbol),
                infoRowWithIcon(Icons.local_offer, 'Tax'.tr, product.tax.toString()),
                infoRowWithIcon(Icons.discount, 'Discount'.tr, (product.discount* ordersController.currentOrder!.exchangerate).toStringAsFixed(0) + ordersController.currentOrder!.currencysymbol),
                infoRowWithIcon(Icons.attach_money, 'Price After Discount'.tr,
                    product.priceAfterDiscount.toString() == ''
                        ? 'No Data Now'.tr
                        : product.priceAfterDiscount.toString()),
                infoRowWithIcon(Icons.inventory_2, 'Quantity'.tr, product.qty.toString()),
                infoRowWithIcon(Icons.local_shipping, 'Delivery Status'.tr, product.deliveryStatus.toString()),
                infoRowWithIcon(Icons.payment, 'Payment Status'.tr, product.paymentStatus.toString()),

                // زر الإضافة للمنتجات المرتجعة
                if (status == OrderStatuses.outForDelivery &&
                    !ordersController.isStartDeliveryButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: AppButton.normalButton(
                      title: ordersController.isProductInReturnedProducts(product)
                          ? 'Remove from returned'.tr
                          : 'Add to returned'.tr,
                      height: 38,
                      width: 150,
                      titleSize: 13,
                      backgroundColor: ordersController.isProductInReturnedProducts(product)
                          ? AppColors.primaryDark
                          : AppColors.secondary,
                      onPress: () {
                        ordersController.addReturnedProducts(product);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget infoRowWithIcon(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          '$title: ',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    ),
  );
}

  

  //mainnnn

  // Widget moreOrderInfoSection(final OrderDataModel order) {
  //   return ListView.builder(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: order.note!.isEmpty ? 15 : 16,
  //     itemBuilder: (context, index) {
  //       if (index == 0) {
  //         return OrderDetailsWidget(
  //           title: 'Order unique id'.tr,
  //           value: order.id == null ? 'No Data Now'.tr : order.id.toString(),
  //         );
  //       }
  //       if (index == 1) {
  //         return OrderDetailsWidget(
  //           title: 'Original Order Id'.tr,
  //           value: order.originalOrderId == null
  //               ? 'No Data Now'.tr
  //               : order.originalOrderId.toString(),
  //         );
  //       }
  //       if (index == 2) {
  //         return OrderDetailsWidget(
  //             title: 'Shipping Cost'.tr,
  //             value: order.shippingAddressData == null
  //                 ? 'No Data Now'.tr
  //                 : order.shippingAddressData!.cost.toString() == ''
  //                     ? 'No Data Now'.tr
  //                     : order.shippingAddressData!.cost.toString());
  //       }
  //       if (index == 3) {
  //         return OrderDetailsWidget(
  //           title: 'Seller Id'.tr,
  //           value: order.sellerId.toString() == ''
  //               ? 'No Data Now'.tr
  //               : order.sellerId.toString(),
  //         );
  //       }
  //       if (index == 4) {
  //         return OrderDetailsWidget(
  //           title: 'Contact Person Name'.tr,
  //           value: !ordersController.isMyOrderPage
  //               ? '* * * * * * * *'
  //               : order.shippingAddressData == null
  //                   ? 'No Data Now'.tr
  //                   : order.shippingAddressData!.contactPersonName.toString() ==
  //                           ''
  //                       ? 'No Data Now'.tr
  //                       : order.shippingAddressData!.contactPersonName
  //                           .toString(),
  //         );
  //       }
  //       if (index == 5) {
  //         return OrderDetailsWidget(
  //           title: 'Address Type'.tr,
  //           value: order.shippingAddressData == null
  //               ? 'No Data Now'.tr
  //               : order.shippingAddressData!.addressType.toString() == ''
  //                   ? 'No Data Now'.tr
  //                   : order.shippingAddressData!.addressType.toString(),
  //         );
  //       }
  //       if (index == 6) {
  //         return OrderDetailsWidget(
  //           title: 'Address'.tr,
  //           value: order.shippingAddressData == null
  //               ? 'No Data Now'.tr
  //               : order.shippingAddressData!.address.toString() == ''
  //                   ? 'No Data Now'.tr
  //                   : order.shippingAddressData!.address.toString(),
  //         );
  //       }
  //       if (index == 7) {
  //         return OrderDetailsWidget(
  //           title: 'City'.tr,
  //           value: order.shippingAddressData == null
  //               ? 'No Data Now'.tr
  //               : order.shippingAddressData!.city.toString() == ''
  //                   ? 'No Data Now'.tr
  //                   : order.shippingAddressData!.city.toString(),
  //         );
  //       }
  //       if (index == 8) {
  //         return OrderDetailsWidget(
  //           title: 'Country'.tr,
  //           value: order.shippingAddressData == null
  //               ? 'No Data Now'.tr
  //               : order.shippingAddressData!.country.toString() == ''
  //                   ? 'No Data Now'.tr
  //                   : order.shippingAddressData!.country.toString(),
  //         );
  //       }
  //       // if (index == 9) {
  //       //   return OrderDetailsWidget(
  //       //     title: 'Phone'.tr,
  //       //     value: !ordersController.isMyOrderPage
  //       //         ? '* * * * * * * *'
  //       //         : order.shippingAddressData == null
  //       //             ? 'No Data Now'.tr
  //       //             : order.shippingAddressData!.phone.toString() == ''
  //       //                 ? 'No Data Now'.tr
  //       //                 : order.shippingAddressData!.phone.toString(),
  //       //     height: !ordersController.isMyOrderPage ? 37 : 60,
  //       //     widget:
  //       //         !ordersController.isMyOrderPage ? null : phoneButtons(order),
  //       //   );
  //       // }
  //       if (index == 9) {
  //         return OrderDetailsWidget(
  //           title: 'Email'.tr,
  //           value: !ordersController.isMyOrderPage
  //               ? '* * * * * * * *'
  //               : order.shippingAddressData == null
  //                   ? 'No Data Now'.tr
  //                   : order.shippingAddressData!.email.toString() == ''
  //                       ? 'No Data Now'.tr
  //                       : order.shippingAddressData!.email.toString(),
  //         );
  //       }
  //       if (index == 10) {
  //         return OrderDetailsWidget(
  //           title: 'Order Amount'.tr,
  //           value: order.orderAmountFormatted == null
  //               ? 'No Data Now'.tr
  //               : order.orderAmountFormatted.toString() == ''
  //                   ? 'No Data Now'.tr
  //                   : order.orderAmountFormatted.toString(),
  //         );
  //       }
  //       if (index == 11) {
  //         return OrderDetailsWidget(
  //           title: 'Received Amount'.tr,
  //           value: order.receivedAmount == ''
  //               ? 'No Data Now'.tr
  //               : order.receivedAmount.toString(),
  //         );
  //       }
  //       if (index == 12) {
  //         return OrderDetailsWidget(
  //           title: 'Created At'.tr,
  //           value: order.createdAt == ''
  //               ? 'No Data Now'.tr
  //               : DateFormat("yyyy-MM-dd HH:mm:ss").format(
  //                   DateTime.parse(order.createdAt.toString()).toLocal()),
  //         );
  //       }
  //       if (index == 13) {
  //         return OrderDetailsWidget(
  //           title: 'Delivery Time'.tr,
  //           value: order.deliveryTime == ''
  //               ? 'No Data Now'.tr
  //               : order.deliveryTime.toString(),
  //         );
  //       }
  //       if (index == 14 && order.note!.isNotEmpty) {
  //         return OrderDetailsWidget(
  //           title: 'Note'.tr,
  //           value: order.note == '' ? 'No Data Now'.tr : order.note.toString(),
  //           height: 70,
  //         );
  //       }
  //       if (order.note!.isNotEmpty) {
  //         if (index == 15) {
  //           return OrderDetailsWidget(
  //             title: 'COD Amount'.tr,
  //             color: AppColors.lightGray,
  //             isBold: true,
  //             value: order.codAmount == null
  //                 ? 'No Data Now'.tr
  //                 : order.codAmount.toString() == ''
  //                     ? 'No Data Now'.tr
  //                     : order.codAmount.toString(),
  //           );
  //         }
  //       } else {
  //         if (index == 16) {
  //           return OrderDetailsWidget(
  //             title: 'COD Amount'.tr,
  //             color: AppColors.lightGray,
  //             isBold: true,
  //             value: order.codAmount == null
  //                 ? 'No Data Now'.tr
  //                 : order.codAmount.toString() == ''
  //                     ? 'No Data Now'.tr
  //                     : order.codAmount.toString(),
  //           );
  //         }
  //       }

  //       return null;
  //     },
  //   );
  // }
  Widget moreOrderInfoSection(final OrderDataModel order) {
  return Card(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: order.note!.isEmpty ? 15 : 16,
        itemBuilder: (context, index) {
          Widget buildItem({
            required IconData icon,
            required String title,
            required String value,
            Color? color,
            bool isBold = false,
            double height = 55,
          }) {
            return Container(
              height: height,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.6,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.blueGrey.shade400, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                            color: color ?? Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // نبدأ من هنا بنفس المنطق تمامًا
          if (index == 0) {
            return buildItem(
              icon: Icons.confirmation_number_outlined,
              title: 'Order unique id'.tr,
              value: order.id == null ? 'No Data Now'.tr : order.id.toString(),
            );
          }
          if (index == 1) {
            return buildItem(
              icon: Icons.qr_code_2,
              title: 'Original Order Id'.tr,
              value: order.originalOrderId == null
                  ? 'No Data Now'.tr
                  : order.originalOrderId.toString(),
            );
          }
          if (index == 2) {
            return buildItem(
              icon: Icons.local_shipping_outlined,
              title: 'Shipping Cost'.tr,
              value: order.shippingAddressData == null
                  ? 'No Data Now'.tr
                  : order.shippingAddressData!.cost.toString() == ''
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.cost.toString(),
            );
          }
          if (index == 3) {
            return buildItem(
              icon: Icons.store_mall_directory_outlined,
              title: 'Seller Id'.tr,
              value: order.sellerId.toString() == ''
                  ? 'No Data Now'.tr
                  : order.sellerId.toString(),
            );
          }
          if (index == 4) {
            return buildItem(
              icon: Icons.person_outline,
              title: 'Contact Person Name'.tr,
              value: !ordersController.isMyOrderPage
                  ? '* * * * * * * *'
                  : order.shippingAddressData == null
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.contactPersonName.toString() == ''
                          ? 'No Data Now'.tr
                          : order.shippingAddressData!.contactPersonName.toString(),
            );
          }
          if (index == 5) {
            return buildItem(
              icon: Icons.home_outlined,
              title: 'Address Type'.tr,
              value: order.shippingAddressData == null
                  ? 'No Data Now'.tr
                  : order.shippingAddressData!.addressType.toString() == ''
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.addressType.toString(),
            );
          }
          if (index == 6) {
            return buildItem(
              icon: Icons.location_on_outlined,
              title: 'Address'.tr,
              value: order.shippingAddressData == null
                  ? 'No Data Now'.tr
                  : order.shippingAddressData!.address.toString() == ''
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.address.toString(),
            );
          }
          if (index == 7) {
            return buildItem(
              icon: Icons.location_city_outlined,
              title: 'City'.tr,
              value: order.shippingAddressData == null
                  ? 'No Data Now'.tr
                  : order.shippingAddressData!.city.toString() == ''
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.city.toString(),
            );
          }
          if (index == 8) {
            return buildItem(
              icon: Icons.flag_outlined,
              title: 'Country'.tr,
              value: order.shippingAddressData == null
                  ? 'No Data Now'.tr
                  : order.shippingAddressData!.country.toString() == ''
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.country.toString(),
            );
          }
          if (index == 9) {
            return buildItem(
              icon: Icons.email_outlined,
              title: 'Email'.tr,
              value: !ordersController.isMyOrderPage
                  ? '* * * * * * * *'
                  : order.shippingAddressData == null
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.email.toString() == ''
                          ? 'No Data Now'.tr
                          : order.shippingAddressData!.email.toString(),
            );
          }
          if (index == 10) {
            return buildItem(
              icon: Icons.attach_money_outlined,
              title: 'Order Amount'.tr,
              value: order.orderAmountFormatted == null
                  ? 'No Data Now'.tr
                  : order.orderAmountFormatted.toString() == ''
                      ? 'No Data Now'.tr
                      : order.orderAmountFormatted.toString(),
            );
          }
          if (index == 11) {
            return buildItem(
              icon: Icons.payments_outlined,
              title: 'Received Amount'.tr,
              value: order.receivedAmount == ''
                  ? 'No Data Now'.tr
                  : order.receivedAmount.toString(),
            );
          }
          if (index == 12) {
            return buildItem(
              icon: Icons.calendar_today_outlined,
              title: 'Created At'.tr,
              value: order.createdAt == ''
                  ? 'No Data Now'.tr
                  : DateFormat("yyyy-MM-dd HH:mm:ss")
                      .format(DateTime.parse(order.createdAt.toString()).toLocal()),
            );
          }
          if (index == 13) {
            return buildItem(
              icon: Icons.access_time_outlined,
              title: 'Delivery Time'.tr,
              value: order.deliveryTime == ''
                  ? 'No Data Now'.tr
                  : order.deliveryTime.toString(),
            );
          }
          if (index == 14 && order.note!.isNotEmpty) {
            return buildItem(
              icon: Icons.note_alt_outlined,
              title: 'Note'.tr,
              value: order.note == '' ? 'No Data Now'.tr : order.note.toString(),
              height: 70,
            );
          }
          if (order.note!.isNotEmpty) {
            if (index == 15) {
              return buildItem(
                icon: Icons.money_rounded,
                title: 'COD Amount'.tr,
                color: AppColors.lightGray,
                isBold: true,
                value: order.codAmount == null
                    ? 'No Data Now'.tr
                    : order.codAmount.toString() == ''
                        ? 'No Data Now'.tr
                        : order.codAmount.toString(),
              );
            }
          } else {
            if (index == 16) {
              return buildItem(
                icon: Icons.money_rounded,
                title: 'COD Amount'.tr,
                color: AppColors.lightGray,
                isBold: true,
                value: order.codAmount == null
                    ? 'No Data Now'.tr
                    : order.codAmount.toString() == ''
                        ? 'No Data Now'.tr
                        : order.codAmount.toString(),
              );
            }
          }

          return const SizedBox.shrink();
        },
      ),
    ),
  );
}


  Widget phoneButtons(OrderDataModel order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () async {
            var url = Uri.parse(
                "tel:${order.shippingAddressData == null ? '' : order.shippingAddressData!.phone}");
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: const Icon(
            Icons.phone,
            size: 20,
            color: AppColors.primaryDark,
          ),
        ),
        ////////////////////////////////
        InkWell(
          onTap: () async {
            var url = Uri.parse(
                "sms:${order.shippingAddressData == null ? '' : order.shippingAddressData!.phone}");
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: const Icon(
            Icons.markunread,
            size: 20,
            color: AppColors.primaryDark,
          ),
        ),
        ////////////////////////////////
        InkWell(
          onTap: () async {
            await Permission.location.isDenied.then((value) async {
              if (value) {
                await Permission.location.request();
              }

              bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                await AppSettings.openAppSettings(
                    type: AppSettingsType.location);
              }
              if (!value && serviceEnabled) {
                ordersController.showChangeOrderStatusCircleIndicator();
                await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high)
                    .then((Position position) async {
                  ordersController.hideChangeOrderStatusCircleIndicator();
                  final maps = Uri.https("google.com", "/maps/search/", {
                    "api=1&query": "${position.latitude},${position.longitude}"
                  });
                  var whatsappUrl = Uri.parse(
                      "whatsapp://send?phone=${order.shippingAddressData == null ? '' : order.shippingAddressData!.phone}+&text=$maps");

                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl);
                  } else {
                    throw 'Could not launch $whatsappUrl';
                  }
                }).catchError((e) {
                  ordersController.hideChangeOrderStatusCircleIndicator();
                  debugPrint(
                      '///////////////////////////catchError on getCurrentPosition////////////////////////');
                  debugPrint(e.toString());
                });
              }
            });
            ///////////////////////////////////////////////////////////////
          },
          child: const Icon(
            Icons.location_on,
            size: 20,
            color: AppColors.primaryDark,
          ),
        ),
        ////////////////////////////////
        InkWell(
          onTap: () async {
            var whatsappUrl = Uri.parse(
                "whatsapp://send?phone=${order.shippingAddressData == null ? '' : order.shippingAddressData!.phone}");

            if (await canLaunchUrl(whatsappUrl)) {
              await launchUrl(whatsappUrl);
            } else {
              throw 'Could not launch $whatsappUrl';
            }
          },
          child: Image.asset(
            'assets/pictures/whats_app.png',
            width: 18,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
        ////////////////////////////////
      ],
    );
  }
  //mainnnn

  // Widget generalInfoSection(
  //     final List<ProductModel>? products, int productsIndex) {
  //   return ListView.builder(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: 6,
  //     itemBuilder: (context, index) {
  //       if (index == 0) {
  //         return OrderDetailsWidget(
  //             title: 'Price'.tr,
  //             value: products![productsIndex].price.toString());
  //       }
  //       if (index == 1) {
  //         return OrderDetailsWidget(
  //             title: 'Tax'.tr, value: products![productsIndex].tax.toString());
  //       }
  //       if (index == 2) {
  //         return OrderDetailsWidget(
  //             title: 'Discount'.tr,
  //             value: products![productsIndex].discount.toString());
  //       }
  //       if (index == 3) {
  //         return OrderDetailsWidget(
  //           title: 'Price After Discount'.tr,
  //           value: products![productsIndex].priceAfterDiscount.toString() == ''
  //               ? 'No Data Now'.tr
  //               : products[productsIndex].priceAfterDiscount.toString(),
  //         );
  //       }
  //       if (index == 4) {
  //         return OrderDetailsWidget(
  //             title: 'Delivery Status'.tr,
  //             value: products![productsIndex].deliveryStatus.toString());
  //       }
  //       if (index == 5) {
  //         return OrderDetailsWidget(
  //             title: 'Payment Status'.tr,
  //             value: products![productsIndex].paymentStatus.toString());
  //       }
  //       /* if (index == 6) {
  //         return OrderDetailsWidget(
  //             title: 'وون',
  //             value: products![productsIndex].paymentStatus.toString());
  //       }*/
  //       return null;
  //     },
  //   );
  // }
  Widget generalInfoSection(final List<ProductModel>? products, int productsIndex) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: 6,
    itemBuilder: (context, index) {
      Widget buildItem({required IconData icon, required String title, required String value}) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icon, color: Colors.blueGrey, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      if (index == 0) {
        return buildItem(
          icon: Icons.price_check_outlined,
          title: 'Price'.tr,
          value: products![productsIndex].price.toString(),
        );
      }
      if (index == 1) {
        return buildItem(
          icon: Icons.receipt_long_outlined,
          title: 'Tax'.tr,
          value: products![productsIndex].tax.toString(),
        );
      }
      if (index == 2) {
        return buildItem(
          icon: Icons.discount_outlined,
          title: 'Discount'.tr,
          value: products![productsIndex].discount.toString(),
        );
      }
      if (index == 3) {
        return buildItem(
          icon: Icons.attach_money_outlined,
          title: 'Price After Discount'.tr,
          value: products![productsIndex].priceAfterDiscount.toString() == ''
              ? 'No Data Now'.tr
              : products[productsIndex].priceAfterDiscount.toString(),
        );
      }
      if (index == 4) {
        return buildItem(
          icon: Icons.local_shipping_outlined,
          title: 'Delivery Status'.tr,
          value: products![productsIndex].deliveryStatus.toString(),
        );
      }
      if (index == 5) {
        return buildItem(
          icon: Icons.payment_outlined,
          title: 'Payment Status'.tr,
          value: products![productsIndex].paymentStatus.toString(),
        );
      }

      return const SizedBox.shrink();
    },
  );
}


  Widget productsSection(
      final List<ProductModel>? products, int productsIndex) {
    return ProductsWidget(
      img: products![productsIndex].productDetails!.images.isNullOrEmpty
          ? (products[productsIndex].productDetails!.image ?? "")
          : products![productsIndex].productDetails!.images![0].toString(),
      title: products[productsIndex].productDetails!.name.toString(),
      price: products[productsIndex].productDetails!.priceFormatted.toString(),
      quantity: products[productsIndex].qty.toString(),
    );
  }
  //mainnnn

  // Widget availableReturnedLocations(OrderDataModel order) {
  //   return Padding(
  //     padding: EdgeInsetsGeometry.only(top: 5, bottom: 5),
  //     child: DropdownButtonFormField<int>(
  //       decoration: InputDecoration(
  //         labelText: "Chose a location".tr,
  //         border: OutlineInputBorder(),
  //       ),
  //       items: order.availableReturnLocation!
  //           .map((loc) => DropdownMenuItem<int>(
  //                 value: loc.originalLocationId,
  //                 child: Text(loc.name ?? ""),
  //               ))
  //           .toList(),
  //       onChanged: (value) {
  //         ordersController.orginalLocationId = value;
  //       },
  //       validator: (value) {
  //         if (value == null) {
  //           return "Chose a location".tr;
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }
  Widget availableReturnedLocations(OrderDataModel order) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: "Choose a location".tr,
          prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.blueGrey),
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.3),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.3),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueGrey),
        items: order.availableReturnLocation!
            .map((loc) => DropdownMenuItem<int>(
                  value: loc.originalLocationId,
                  child: Text(
                    loc.name ?? "",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          ordersController.orginalLocationId = value;
        },
        validator: (value) {
          if (value == null) {
            return "Choose a location".tr;
          }
          return null;
        },
      ),
    ),
  );
}

}
