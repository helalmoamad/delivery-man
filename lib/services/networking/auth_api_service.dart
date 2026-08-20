import 'package:delivery_man_app/models/Auth/chat_login_model.dart'
    show ChatLoginModel;
import 'package:delivery_man_app/models/Auth/send_otp_model.dart';
import 'package:delivery_man_app/models/Auth/verify_otp_model.dart'
    show OtpVerificationResponse;
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

  Future<OtpResponse> sendOtpApi({
    required String phone,
    required int isViaWhatsapp,
  });

  Future<OtpVerificationResponse> verifyOtpApi({
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

    final response = await ApiMethodsDelivery.postRequest<UserModel>(
      urlPath: 'users/login',
      token: '',
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      body: loginModel.toJson(),
      fromJson: UserModel.fromJson,
    );
    return response!;
  }

  @override
  Future<SetFcmTokenModel> setFcmTokenApi({
    required String token,
    required String fcmToken,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethodsDelivery.postRequest<SetFcmTokenModel>(
      urlPath: 'users/set_fcm_token',
      token: token,
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      body: {'fcm_token': fcmToken},
      fromJson: SetFcmTokenModel.fromJson,
    );
    return response!;
  }

  @override
  Future<LogOutModel> postLogoutApi({
    required String token,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethodsDelivery.postRequest<LogOutModel>(
      urlPath: 'users/logout',
      token: token,
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      body: {},
      fromJson: LogOutModel.fromJson,
    );

    return response!;
  }

  @override
  Future<OtpResponse> sendOtpApi({
    required String phone,
    required int isViaWhatsapp,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethodsDelivery.postRequest<OtpResponse>(
      urlPath: 'users/get_otp',
      token: '',
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      isForOtp: true,
      body: {
        'mobile_phone': phone,
        'is_via_whatsapp': isViaWhatsapp == 1 ? true : false,
      },
      fromJson: OtpResponse.fromJson,
    );

    return response!;
  }

  @override
  Future<OtpVerificationResponse> verifyOtpApi({
    required String verificationId,
    required String otp,
  }) async {
    clientController.reOpenClient();

    final response =
        await ApiMethodsDelivery.postRequest<OtpVerificationResponse>(
      urlPath: 'users/check_and_login',
      token: '',
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      isForOtp: true,
      body: {
        'session_info': verificationId,
        'otp_code': otp,
      },
      fromJson: OtpVerificationResponse.fromJson,
    );

    return response!;
  }

  @override
  Future<ChatLoginModel> chatLoginApi({
    required String mobilePhone,
    required String otpIdToken,
    required String name,
    required int originalUserId,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethodsDelivery.postRequest<ChatLoginModel>(
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
        'delivery_user_id': originalUserId,
      },
      fromJson: ChatLoginModel.fromJson,
    );

    return response!;
  }
}
