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
  }
}
