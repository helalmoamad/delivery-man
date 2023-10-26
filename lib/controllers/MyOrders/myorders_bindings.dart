import 'package:delivery_man_app/controllers/MyOrders/myorders_controller.dart';
import 'package:get/get.dart';

class MyOrdersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyOrdersController>(() => MyOrdersController());
    ////// My Orders /////////////////////////////////////
    // Get.lazyPut<OrdersApiService>(() => OrdersApiServiceImpWithHttp(
    //     clientController: Get.find<HttpClientController>()));
    // Get.lazyPut<OrdersRepository>(() => OrdersRepository(
    //     ordersApiService: Get.find(), networkInfo: Get.find()));
    // Get.lazyPut<GetListOrderDataProvider>(
    //   () => GetListOrderDataProvider(Get.find()),
    // );

    // Get.lazyPut<GetOrderStatusDataProvider>(
    //   () => GetOrderStatusDataProvider(Get.find()),
    // );

    // Get.lazyPut<UnAssignToVehicleProvider>(
    //   () => UnAssignToVehicleProvider(Get.find()),
    // );
  }
}
