import 'package:delivery_man_app/controllers/Client/client_controller.dart';
import 'package:delivery_man_app/controllers/QR/qr_controller.dart';
import 'package:delivery_man_app/providers/AssignToVehicle_providers/assign_to_vehicle_provider.dart';
import 'package:delivery_man_app/repositories/assign_to_vehicle_repository.dart';
import 'package:delivery_man_app/services/networking/assign_to_vehicle_api_service.dart';
import 'package:get/get.dart';

class QRBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QRController>(() => QRController());

    Get.lazyPut<AssignToVehicleService>(() => AssignToVehicleServiceImpWithHttp(
        clientController: Get.find<HttpClientController>()));
    Get.lazyPut<AssignToVehicleRepository>(() => AssignToVehicleRepository(
        assignToVehicleService: Get.find(), networkInfo: Get.find()));
    Get.lazyPut<AssignToVehicleProvider>(
      () => AssignToVehicleProvider(Get.find()),
    );
  }
}
