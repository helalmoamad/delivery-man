import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Auth/chat_login_model.dart'
    show ChatLoginModel;
import 'package:delivery_man_app/models/Auth/send_otp_model.dart'
    show SendOtpResponseModel;
import 'package:delivery_man_app/models/Auth/verify_otp_model.dart'
    show VerifyOtpResponseModel;
import 'package:delivery_man_app/repositories/repo_network_request.dart';
import '../models/Auth/fcm_token_model.dart';
import '../models/Auth/login_model.dart';
import '../models/Auth/user_data_model.dart';
import '../services/networking/auth_api_service.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final NetworkInfo networkInfo;

  AuthRepository({required this.authApiService, required this.networkInfo});

  Future<Either<FailureDelivery, UserModel>> postLogin(
      LoginModel loginModel) async {
    return RepoNetworkRequest.makeNetworkRequest<UserModel>(
      networkInfo: networkInfo,
      request: () => authApiService.postLoginApi(loginModel),
    );
  }

  Future<Either<FailureDelivery, SetFcmTokenModel>> setFcmToken({
    required String token,
    required String fcmToken,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<SetFcmTokenModel>(
      networkInfo: networkInfo,
      request: () =>
          authApiService.setFcmTokenApi(token: token, fcmToken: fcmToken),
    );
  }

  Future<Either<FailureDelivery, Unit>> postLogout({
    required String token,
  }) async {
    return RepoNetworkRequest.makeNetworkRequestUnit(
      networkInfo: networkInfo,
      request: () => authApiService.postLogoutApi(
        token: token,
      ),
    );
  }

  Future<Either<FailureDelivery, SendOtpResponseModel>> postsendOtp({
    required String phone,
    required int isViaWhatsapp,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest(
      networkInfo: networkInfo,
      request: () => authApiService.sendOtpApi(
        phone: phone,
        isViaWhatsapp: isViaWhatsapp,
      ),
    );
  }

  Future<Either<FailureDelivery, VerifyOtpResponseModel>> postVerifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest(
      networkInfo: networkInfo,
      request: () => authApiService.verifyOtpApi(
        verificationId: verificationId,
        otp: otp,
      ),
    );
  }

  Future<Either<FailureDelivery, ChatLoginModel>> chatLoginApi({
    required String mobilePhone,
    required String otpIdToken,
    required String name,
    required int originalUserId,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest(
      networkInfo: networkInfo,
      request: () => authApiService.chatLoginApi(
        mobilePhone: mobilePhone,
        name: name,
        originalUserId: originalUserId,
        otpIdToken: otpIdToken,
      ),
    );
  }
}
