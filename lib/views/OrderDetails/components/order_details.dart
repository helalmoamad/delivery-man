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
      status = (GetIt.I<PrefsRepository>().myOrderIdForChat != "" &&
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 3,
                  width: double.infinity,
                  color: AppColors.primaryDark,
                ),
              ),
              // ////////////////////////////////
              moreOrderInfoSection(order),
              ///////////////
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 3,
                  width: double.infinity,
                  color: AppColors.primaryDark,
                ),
              ),
              if (order.orderStatus == OrderStatuses.returnedToDeliveryCenter)
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 3,
                  width: double.infinity,
                  color: AppColors.primaryDark,
                ),
              ),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 3,
                          width: double.infinity,
                          color: AppColors.primaryDark,
                        ),
                      );
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 3,
                  width: double.infinity,
                  color: AppColors.primaryDark,
                ),
              ),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      height: 3,
                      width: double.infinity,
                      color: AppColors.primaryDark,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductsSection(OrderDataModel order,
      List<ProductModel>? products, int productsIndex, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////
        TitleSectionWidget(
          title: 'Product'.tr,
          index: '#${productsIndex + 1}  ',
          widget: (status == OrderStatuses.outForDelivery &&
                  !ordersController.isStartDeliveryButton)
              ? AppButton.normalButton(
                  title: ordersController
                          .isProductInReturnedProducts(products![productsIndex])
                      ? 'Remove from returned'.tr
                      : 'Add to returned'.tr,
                  height: 35,
                  width: 100,
                  titleSize: 13,
                  backgroundColor: ordersController
                          .isProductInReturnedProducts(products[productsIndex])
                      ? AppColors.primaryDark
                      : AppColors.secondary,
                  onPress: () {
                    ordersController
                        .addReturnedProducts(products[productsIndex]);
                  })
              : null,
        ),
        productsSection(products, productsIndex),
        ////////////////////////////
        TitleSectionWidget(
          title: 'General Info'.tr,
          index: '',
        ),
        /////////////////////
        generalInfoSection(products, productsIndex),
      ],
    );
  }

  Widget moreOrderInfoSection(final OrderDataModel order) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: order.note!.isEmpty ? 15 : 16,
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrderDetailsWidget(
            title: 'Order unique id'.tr,
            value: order.id == null ? 'No Data Now'.tr : order.id.toString(),
          );
        }
        if (index == 1) {
          return OrderDetailsWidget(
            title: 'Original Order Id'.tr,
            value: order.originalOrderId == null
                ? 'No Data Now'.tr
                : order.originalOrderId.toString(),
          );
        }
        if (index == 2) {
          return OrderDetailsWidget(
              title: 'Shipping Cost'.tr,
              value: order.shippingAddressData == null
                  ? 'No Data Now'.tr
                  : order.shippingAddressData!.cost.toString() == ''
                      ? 'No Data Now'.tr
                      : order.shippingAddressData!.cost.toString());
        }
        if (index == 3) {
          return OrderDetailsWidget(
            title: 'Seller Id'.tr,
            value: order.sellerId.toString() == ''
                ? 'No Data Now'.tr
                : order.sellerId.toString(),
          );
        }
        if (index == 4) {
          return OrderDetailsWidget(
            title: 'Contact Person Name'.tr,
            value: !ordersController.isMyOrderPage
                ? '* * * * * * * *'
                : order.shippingAddressData == null
                    ? 'No Data Now'.tr
                    : order.shippingAddressData!.contactPersonName.toString() ==
                            ''
                        ? 'No Data Now'.tr
                        : order.shippingAddressData!.contactPersonName
                            .toString(),
          );
        }
        if (index == 5) {
          return OrderDetailsWidget(
            title: 'Address Type'.tr,
            value: order.shippingAddressData == null
                ? 'No Data Now'.tr
                : order.shippingAddressData!.addressType.toString() == ''
                    ? 'No Data Now'.tr
                    : order.shippingAddressData!.addressType.toString(),
          );
        }
        if (index == 6) {
          return OrderDetailsWidget(
            title: 'Address'.tr,
            value: order.shippingAddressData == null
                ? 'No Data Now'.tr
                : order.shippingAddressData!.address.toString() == ''
                    ? 'No Data Now'.tr
                    : order.shippingAddressData!.address.toString(),
          );
        }
        if (index == 7) {
          return OrderDetailsWidget(
            title: 'City'.tr,
            value: order.shippingAddressData == null
                ? 'No Data Now'.tr
                : order.shippingAddressData!.city.toString() == ''
                    ? 'No Data Now'.tr
                    : order.shippingAddressData!.city.toString(),
          );
        }
        if (index == 8) {
          return OrderDetailsWidget(
            title: 'Country'.tr,
            value: order.shippingAddressData == null
                ? 'No Data Now'.tr
                : order.shippingAddressData!.country.toString() == ''
                    ? 'No Data Now'.tr
                    : order.shippingAddressData!.country.toString(),
          );
        }
        // if (index == 9) {
        //   return OrderDetailsWidget(
        //     title: 'Phone'.tr,
        //     value: !ordersController.isMyOrderPage
        //         ? '* * * * * * * *'
        //         : order.shippingAddressData == null
        //             ? 'No Data Now'.tr
        //             : order.shippingAddressData!.phone.toString() == ''
        //                 ? 'No Data Now'.tr
        //                 : order.shippingAddressData!.phone.toString(),
        //     height: !ordersController.isMyOrderPage ? 37 : 60,
        //     widget:
        //         !ordersController.isMyOrderPage ? null : phoneButtons(order),
        //   );
        // }
        if (index == 9) {
          return OrderDetailsWidget(
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
          return OrderDetailsWidget(
            title: 'Order Amount'.tr,
            value: order.orderAmountFormatted == null
                ? 'No Data Now'.tr
                : order.orderAmountFormatted.toString() == ''
                    ? 'No Data Now'.tr
                    : order.orderAmountFormatted.toString(),
          );
        }
        if (index == 11) {
          return OrderDetailsWidget(
            title: 'Received Amount'.tr,
            value: order.receivedAmount == ''
                ? 'No Data Now'.tr
                : order.receivedAmount.toString(),
          );
        }
        if (index == 12) {
          return OrderDetailsWidget(
            title: 'Created At'.tr,
            value: order.createdAt == ''
                ? 'No Data Now'.tr
                : DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.parse(order.createdAt.toString()).toLocal()),
          );
        }
        if (index == 13) {
          return OrderDetailsWidget(
            title: 'Delivery Time'.tr,
            value: order.deliveryTime == ''
                ? 'No Data Now'.tr
                : order.deliveryTime.toString(),
          );
        }
        if (index == 14 && order.note!.isNotEmpty) {
          return OrderDetailsWidget(
            title: 'Note'.tr,
            value: order.note == '' ? 'No Data Now'.tr : order.note.toString(),
            height: 70,
          );
        }
        if (order.note!.isNotEmpty) {
          if (index == 15) {
            return OrderDetailsWidget(
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
            return OrderDetailsWidget(
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

        return null;
      },
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

  Widget generalInfoSection(
      final List<ProductModel>? products, int productsIndex) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrderDetailsWidget(
              title: 'Price'.tr,
              value: products![productsIndex].price.toString());
        }
        if (index == 1) {
          return OrderDetailsWidget(
              title: 'Tax'.tr, value: products![productsIndex].tax.toString());
        }
        if (index == 2) {
          return OrderDetailsWidget(
              title: 'Discount'.tr,
              value: products![productsIndex].discount.toString());
        }
        if (index == 3) {
          return OrderDetailsWidget(
            title: 'Price After Discount'.tr,
            value: products![productsIndex].priceAfterDiscount.toString() == ''
                ? 'No Data Now'.tr
                : products[productsIndex].priceAfterDiscount.toString(),
          );
        }
        if (index == 4) {
          return OrderDetailsWidget(
              title: 'Delivery Status'.tr,
              value: products![productsIndex].deliveryStatus.toString());
        }
        if (index == 5) {
          return OrderDetailsWidget(
              title: 'Payment Status'.tr,
              value: products![productsIndex].paymentStatus.toString());
        }
        /* if (index == 6) {
          return OrderDetailsWidget(
              title: 'وون',
              value: products![productsIndex].paymentStatus.toString());
        }*/
        return null;
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

  Widget availableReturnedLocations(OrderDataModel order) {
    return Padding(
      padding: EdgeInsetsGeometry.only(top: 5, bottom: 5),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: "Chose a location".tr,
          border: OutlineInputBorder(),
        ),
        items: order.availableReturnLocation!
            .map((loc) => DropdownMenuItem<int>(
                  value: loc.originalLocationId,
                  child: Text(loc.name ?? ""),
                ))
            .toList(),
        onChanged: (value) {
          ordersController.orginalLocationId = value;
        },
        validator: (value) {
          if (value == null) {
            return "Chose a location".tr;
          }
          return null;
        },
      ),
    );
  }
}
