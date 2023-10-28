import 'package:delivery_man_app/controllers/MyOrders/myorders_controller.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/get_my_orders_provider.dart';
import 'package:get/get.dart';

class MyOrdersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOrdersController>(() => MyOrdersController());
    ////// My Orders /////////////////////////////////////
    Get.lazyPut<GetMyOrdersProvider>(
      () => GetMyOrdersProvider(Get.find()),
    );
  }
}
