import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/views/OrderDetails/components/product_widget.dart';
import 'package:delivery_man_app/views/OrderDetails/components/title_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/Orders/list_order_model.dart';
import '../../../shared/constants/color_constants.dart';
import 'order_details_widget.dart';

class OrderDetails extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();

  OrderDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int orderIndex;
    String status;
    final Order order;
    if (ordersController.previousRoute == Routes.myOrdersPage) {
      orderIndex = ordersController.myOrderIndex;
      order = ordersController.myOrdersData.data!.data![orderIndex];
      status = ordersController.myOrderStatus;
    } else {
      orderIndex = ordersController.orderIndex;
      order = ordersController.ordersData.data!.data![orderIndex];
      status = ordersController.orderStatus;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            right: 5,
            left: 5,
            top: 0,
            bottom: (status == 'ready_to_shipping' ||
                    status == 'shipped' ||
                    status == 'out_for_delivery')
                ? 101
                : 10),
        child: Column(
          children: [
            Column(
              children: [
                TitleSectionWidget(
                  title: 'More Order Info'.tr,
                  index: '',
                ),
                ///////////
                moreOrderInfoSection(order),
                //////////
                TitleSectionWidget(
                  title: 'Shipping Address Info'.tr,
                  index: '',
                ),
                ////////////////////////////////
                shippingAdressInfoSection(order),
                //////////
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                height: 3,
                width: double.infinity,
                color: AppColors.primaryDark,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.details!.length,
              itemBuilder: (context, index) {
                return buildProductsSection(order, index);
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
    );
  }

  Widget buildProductsSection(Order order, int detailsIndex) {
    return Column(
      children: [
        ////////////////////////////////
        TitleSectionWidget(
          title: 'Product'.tr,
          index: '#${detailsIndex + 1}  ',
        ),
        productsSection(order, detailsIndex),
        ////////////////////////////
        TitleSectionWidget(
          title: 'General Info'.tr,
          index: '',
        ),
        /////////////////////
        generalInfoSection(order, detailsIndex),
      ],
    );
  }

  Widget moreOrderInfoSection(final Order order) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrderDetailsWidget(
              title: 'Discount Amount'.tr,
              value: order.details![0].discount.toString());
        }
        if (index == 1) {
          return OrderDetailsWidget(
              title: 'Discount Type'.tr,
              value: order.details![0].discountType.toString());
        }
        if (index == 2) {
          return OrderDetailsWidget(
              title: 'Shipping Cost'.tr,
              value: order.shippingAddressData!.cost.toString());
        }
        if (index == 3) {
          return OrderDetailsWidget(
              title: 'Seller Id'.tr, value: order.sellerId.toString());
        }

        return null;
      },
    );
  }

  Widget shippingAdressInfoSection(final Order order) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 7,
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrderDetailsWidget(
              title: 'Contact Person Name'.tr,
              value: order.shippingAddressData!.contactPersonName.toString());
        }
        if (index == 1) {
          return OrderDetailsWidget(
              title: 'Address Type'.tr,
              value: order.shippingAddressData!.addressType.toString());
        }
        if (index == 2) {
          return OrderDetailsWidget(
              title: 'Address'.tr,
              value: order.shippingAddressData!.address.toString());
        }
        if (index == 3) {
          return OrderDetailsWidget(
              title: 'City'.tr,
              value: order.shippingAddressData!.city.toString());
        }
        if (index == 4) {
          return OrderDetailsWidget(
              title: 'Country'.tr,
              value: order.shippingAddressData!.country.toString());
        }
        if (index == 5) {
          return OrderDetailsWidget(
              title: 'Phone'.tr, value: '${order.shippingAddressData!.phone}');
        }
        if (index == 6) {
          return OrderDetailsWidget(
              title: 'Email'.tr,
              value: order.shippingAddressData!.email.toString());
        }

        return null;
      },
    );
  }

  Widget generalInfoSection(final Order order, int detailsIndex) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrderDetailsWidget(
              title: 'Price'.tr,
              value: order.details![detailsIndex].price.toString());
        }
        if (index == 1) {
          return OrderDetailsWidget(
              title: 'Tax'.tr,
              value: order.details![detailsIndex].tax.toString());
        }
        if (index == 2) {
          return OrderDetailsWidget(
              title: 'Discount'.tr,
              value: order.details![detailsIndex].discount.toString());
        }
        if (index == 3) {
          return OrderDetailsWidget(
              title: 'Price After Discount'.tr,
              value:
                  order.details![detailsIndex].priceAfterDiscount.toString());
        }
        if (index == 4) {
          return OrderDetailsWidget(
              title: 'Delivery Status'.tr,
              value: order.details![detailsIndex].deliveryStatus.toString());
        }
        if (index == 5) {
          return OrderDetailsWidget(
              title: 'Payment Status'.tr,
              value: order.details![detailsIndex].paymentStatus.toString());
        }
        return null;
      },
    );
  }

  Widget productsSection(final Order order, int detailsIndex) {
    return ProductsWidget(
      img: order.details![detailsIndex].productDetails!.images![0].toString(),
      title: order.details![detailsIndex].productDetails!.name.toString(),
      price: order.details![detailsIndex].productDetails!.priceFormatted
          .toString(),
      quantity: order.details![detailsIndex].qty.toString(),
    );
  }
}
