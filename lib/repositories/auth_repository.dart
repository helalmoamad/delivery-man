import 'dart:async';
import 'package:dartz/dartz.dart';
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

  Future<Either<Failure, UserModel>> postLogin(LoginModel loginModel) async {
    return RepoNetworkRequest.makeNetworkRequest<UserModel>(
      networkInfo: networkInfo,
      request: () => authApiService.postLoginApi(loginModel),
    );
  }

  Future<Either<Failure, SetFcmTokenModel>> setFcmToken({
    required String token,
    required String fcmToken,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<SetFcmTokenModel>(
      networkInfo: networkInfo,
      request: () =>
          authApiService.setFcmTokenApi(token: token, fcmToken: fcmToken),
    );
  }
}
