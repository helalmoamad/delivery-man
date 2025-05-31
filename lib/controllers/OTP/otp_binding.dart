import 'package:delivery_man_app/controllers/OTP/otp_controller.dart';
import 'package:get/get.dart';

class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
