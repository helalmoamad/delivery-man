import 'package:delivery_man_app/models/Auth/chat_login_model.dart'
    show ChatLoginModel;
import 'package:delivery_man_app/models/Auth/send_otp_model.dart'
    show SendOtpResponseModel;
import 'package:delivery_man_app/models/Auth/verify_otp_model.dart'
    show VerifyOtpResponseModel;
import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import '../../controllers/Client/client_controller.dart';
import '../../controllers/Client/timer_service.dart';
import '../../models/Auth/fcm_token_model.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/logout_model.dart';
import '../../models/Auth/user_data_model.dart';

abstract class AuthApiService {
  Future<UserModel> postLoginApi(LoginModel loginModel);

  Future<SetFcmTokenModel> setFcmTokenApi(
      {required String token, required String fcmToken});

  Future<LogOutModel> postLogoutApi({required String token});

  Future<SendOtpResponseModel> sendOtpApi({
    required String phone,
    required int isViaWhatsapp,
  });

  Future<VerifyOtpResponseModel> verifyOtpApi({
    required String verificationId,
    required String otp,
  });

  Future<ChatLoginModel> chatLoginApi({
    required String mobilePhone,
    required String otpIdToken,
    required String name,
    required int originalUserId,
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

  @override
  Future<LogOutModel> postLogoutApi({
    required String token,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethods.postRequest<LogOutModel>(
      urlPath: 'users/logout',
      token: token,
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      body: {},
      fromJson: LogOutModel.fromJson,
    );

    return response;
  }

  @override
  Future<SendOtpResponseModel> sendOtpApi({
    required String phone,
    required int isViaWhatsapp,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethods.getRequest<SendOtpResponseModel>(
      urlPath:
          'auth/phone/send_otp?phone=$phone&is_via_whatsapp=$isViaWhatsapp',
      isMarketUrl: true,
      token: '',
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      isForOtp: true,
      fromJson: SendOtpResponseModel.fromJson,
    );

    return response;
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtpApi({
    required String verificationId,
    required String otp,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethods.getRequest<VerifyOtpResponseModel>(
      urlPath: 'auth/phone/verify_otp?verificationId=$verificationId&otp=$otp',
      isMarketUrl: true,
      token: '',
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      isForOtp: true,
      fromJson: VerifyOtpResponseModel.fromJson,
    );

    return response;
  }

  @override
  Future<ChatLoginModel> chatLoginApi({
    required String mobilePhone,
    required String otpIdToken,
    required String name,
    required int originalUserId,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethods.postRequest<ChatLoginModel>(
      urlPath: 'users/login',
      token: '',
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      isChatUrl: true,
      body: {
        'mobile_phone': mobilePhone,
        'otp_id_token': otpIdToken,
        'name': name,
        'original_user_id': originalUserId,
      },
      fromJson: ChatLoginModel.fromJson,
    );

    return response;
  }
}
