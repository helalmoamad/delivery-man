import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
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
    final OrderModel order;
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
            // ////////////////////////////////
            TitleSectionWidget(
              title: 'Order Products'.tr,
              index: '',
              widget: (status == 'out_for_delivery' &&
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.products!.length,
              itemBuilder: (context, index) {
                return buildProductsSection(order.products, index, status);
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
                    order.returnedProducts, index, status);
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

  Widget buildProductsSection(
      List<ProductModel>? products, int productsIndex, String status) {
    return Column(
      children: [
        ////////////////////////////////
        TitleSectionWidget(
          title: 'Product'.tr,
          index: '#${productsIndex + 1}  ',
          widget: (status == 'out_for_delivery' &&
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

  Widget moreOrderInfoSection(final OrderModel order) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 9,
      itemBuilder: (context, index) {
        if (index == 0) {
          return OrderDetailsWidget(
              title: 'Shipping Cost'.tr,
              value: order.shippingAddressData!.cost.toString());
        }
        if (index == 1) {
          return OrderDetailsWidget(
              title: 'Seller Id'.tr, value: order.sellerId.toString());
        }
        if (index == 2) {
          return OrderDetailsWidget(
              title: 'Contact Person Name'.tr,
              value: order.shippingAddressData!.contactPersonName.toString());
        }
        if (index == 3) {
          return OrderDetailsWidget(
              title: 'Address Type'.tr,
              value: order.shippingAddressData!.addressType.toString());
        }
        if (index == 4) {
          return OrderDetailsWidget(
              title: 'Address'.tr,
              value: order.shippingAddressData!.address.toString());
        }
        if (index == 5) {
          return OrderDetailsWidget(
              title: 'City'.tr,
              value: order.shippingAddressData!.city.toString());
        }
        if (index == 6) {
          return OrderDetailsWidget(
              title: 'Country'.tr,
              value: order.shippingAddressData!.country.toString());
        }
        if (index == 7) {
          return OrderDetailsWidget(
              title: 'Phone'.tr, value: '${order.shippingAddressData!.phone}');
        }
        if (index == 8) {
          return OrderDetailsWidget(
              title: 'Email'.tr,
              value: order.shippingAddressData!.email.toString());
        }

        return null;
      },
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
              value: products![productsIndex].priceAfterDiscount.toString());
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
        return null;
      },
    );
  }

  Widget productsSection(
      final List<ProductModel>? products, int productsIndex) {
    return ProductsWidget(
      img: products![productsIndex].productDetails!.images![0].toString(),
      title: products[productsIndex].productDetails!.name.toString(),
      price: products[productsIndex].productDetails!.priceFormatted.toString(),
      quantity: products[productsIndex].qty.toString(),
    );
  }
}
