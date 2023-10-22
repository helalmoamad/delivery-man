import 'package:delivery_man_app/controllers/QR/qr_controller.dart';
import 'package:get/get.dart';

class QRBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QRController>(() => QRController());
  }
}
