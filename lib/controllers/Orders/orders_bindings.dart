import 'package:get/get.dart';
import '../../providers/Orders_providers.dart/get_order_list_provider.dart';
import '../../providers/Orders_providers.dart/get_order_status_data.dart';
import '../../repositories/order_repository.dart';
import '../../services/networking/orders_api_service.dart';
import '../Client/client_controller.dart';
import 'orders_controller.dart';

class OrdersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(() => OrdersController());
    ////// Order /////////////////////////////////////
    Get.lazyPut<OrdersApiService>(() => OrdersApiServiceImpWithHttp(
        clientController: Get.find<HttpClientController>()));
    Get.lazyPut<OrdersRepository>(() => OrdersRepository(
        ordersApiService: Get.find(), networkInfo: Get.find()));
    Get.lazyPut<GetListOrderDataProvider>(
      () => GetListOrderDataProvider(Get.find()),
    );

    Get.lazyPut<GetOrderStatusDataProvider>(
      () => GetOrderStatusDataProvider(Get.find()),
    );
  }
}
