import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/providers/Auth_providers/chat_login_provider.dart';
import 'package:delivery_man_app/providers/Auth_providers/send_otp_provider.dart'
    show SendOtpProvider;
import 'package:delivery_man_app/providers/Auth_providers/verify_otp_provider.dart';
import 'package:get/get.dart';
import '../../providers/Auth_providers/login_provider.dart';
import '../../providers/Auth_providers/logout_provider.dart';
import '../../providers/Auth_providers/set_fcm_token_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../services/networking/auth_api_service.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    ///////////Auth///////////////////////////////////////////////////////////////
    Get.lazyPut<AuthApiService>(() => AuthApiServiceImpWithHttp(
          clientController: Get.find(),
          timerService: Get.find(),
        ));
    Get.lazyPut<AuthRepository>(() =>
        AuthRepository(networkInfo: Get.find(), authApiService: Get.find()));
    Get.lazyPut<LoginProvider>(() => LoginProvider(Get.find()));
    Get.lazyPut<SetFcmTokenProvider>(() => SetFcmTokenProvider(Get.find()));
    Get.lazyPut<LogOutProvider>(() => LogOutProvider(Get.find()));
    Get.lazyPut<SendOtpProvider>(() => SendOtpProvider(Get.find()));
    Get.lazyPut<VerifyOtpProvider>(() => VerifyOtpProvider(Get.find()));
    Get.lazyPut<ChatLoginProvider>(() => ChatLoginProvider(Get.find()));
    Get.lazyPut<AuthController>(() => AuthController());

  }
}
