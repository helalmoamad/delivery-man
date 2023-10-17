import 'package:delivery_man_app/views/OrderDetails/components/product_widget.dart';
import 'package:delivery_man_app/views/OrderDetails/components/title_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/Orders/orders_controller.dart';
import '../../../models/Orders/list_order_model.dart';
import 'order_details_widget.dart';

class OrderDetails extends StatelessWidget {
  final OrdersController ordersController = Get.find<OrdersController>();
  final int detailsIndex;
  OrderDetails({super.key, required this.detailsIndex});

  @override
  Widget build(BuildContext context) {
    int orderIndex = Get.arguments[0];
    final order = ordersController.ordersData.data!.orders![orderIndex];
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5, top: 0, bottom: 10),
      child: Column(
        children: [
          ////////////////////////////////
          TitleSectionWidget(
            title: '#${detailsIndex + 1}  Product',
          ),
          productsSection(order),
          ////////////////////////////
          const TitleSectionWidget(
            title: 'General Info',
          ),
          /////////////////////
          generalInfoSection(order),
          ////////////////////////////////
        ],
      ),
    );
  }

  Widget generalInfoSection(final Order order) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrderDetailsWidget(
              title: 'Price',
              value: order.details![detailsIndex].price.toString());
        }
        if (index == 1) {
          return OrderDetailsWidget(
              title: 'Tax', value: order.details![detailsIndex].tax.toString());
        }
        if (index == 2) {
          return OrderDetailsWidget(
              title: 'Discount',
              value: order.details![detailsIndex].discount.toString());
        }
        if (index == 3) {
          return OrderDetailsWidget(
              title: 'Price After Discount',
              value:
                  order.details![detailsIndex].priceAfterDiscount.toString());
        }
        if (index == 4) {
          return OrderDetailsWidget(
              title: 'Delivery Status',
              value: order.details![detailsIndex].deliveryStatus.toString());
        }
        if (index == 5) {
          return OrderDetailsWidget(
              title: 'Payment Status',
              value: order.details![detailsIndex].paymentStatus.toString());
        }
        return null;
      },
    );
  }

  Widget productsSection(final Order order) {
    return ProductsWidget(
      img: order.details![detailsIndex].productDetails!.images![0].toString(),
      title: order.details![detailsIndex].productDetails!.name.toString(),
      price: order.details![detailsIndex].productDetails!.priceFormatted
          .toString(),
      quantity: order.details![detailsIndex].qty.toString(),
    );
  }
}
