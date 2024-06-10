import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import '../../controllers/Client/client_controller.dart';
import '../../controllers/Client/timer_service.dart';
import '../../models/Auth/fcm_token_model.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/user_data_model.dart';

abstract class AuthApiService {
  Future<UserModel> postLoginApi(LoginModel loginModel);
  Future<SetFcmTokenModel> setFcmTokenApi({
    required String token,
    required String fcmToken,
  });
}

class AuthApiServiceImpWithHttp implements AuthApiService {
  final HttpClientService clientController;
  final TimerService timerService;

  AuthApiServiceImpWithHttp(
      {required this.clientController, required this.timerService});

  @override
  Future<UserModel> postLoginApi(LoginModel loginModel) async {
    clientController.reOpenClient();

    final response = await ApiMethods.postRequest<UserModel>(
      urlPath: 'users/login',
      token: '',
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      body: loginModel.toJson(),
      fromJson: UserModel.fromJson,
    );
    return response;
  }

  @override
  Future<SetFcmTokenModel> setFcmTokenApi({
    required String token,
    required String fcmToken,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethods.postRequest<SetFcmTokenModel>(
      urlPath: 'users/set_fcm_token',
      token: token,
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      body: {'fcm_token': fcmToken},
      fromJson: SetFcmTokenModel.fromJson,
    );
    return response;
  }
}
