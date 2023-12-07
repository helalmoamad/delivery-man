import 'package:delivery_man_app/providers/Orders_providers.dart/assign_order_tome_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/change_order_received_amount_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/change_order_status.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/get_my_orders_provider.dart';
import 'package:delivery_man_app/providers/Orders_providers.dart/unassign_to_vehicle_provider.dart';
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

    Get.lazyPut<UnAssignToVehicleProvider>(
      () => UnAssignToVehicleProvider(Get.find()),
    );

    Get.lazyPut<AssignOrderToMeProvider>(
      () => AssignOrderToMeProvider(Get.find()),
    );

    Get.lazyPut<ChangeOrderStatusProvider>(
      () => ChangeOrderStatusProvider(Get.find()),
    );

    Get.lazyPut<GetMyOrdersProvider>(
      () => GetMyOrdersProvider(Get.find()),
    );

    Get.lazyPut<ChangeOrderReceivedAmountProvider>(
      () => ChangeOrderReceivedAmountProvider(Get.find()),
    );
  }
}
