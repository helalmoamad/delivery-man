import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import '../models/Auth/login_model.dart';
import '../models/Auth/user_data_model.dart';
import '../services/networking/auth_api_service.dart';
import '../shared/errors/exceptions.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';

class AuthRepository {
  final AuthApiService authApiService;
  final NetworkInfo networkInfo;

  AuthRepository({required this.authApiService, required this.networkInfo});

  Future<Either<Failure, UserModel>> postLogin(LoginModel loginModel) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await authApiService.postLoginApi(loginModel);
        return Right(authResponse);
      } on ServerException {
        return left(ServerFailure());
      } on WrongDataException {
        return left(WrongDataFailure());
      } on ClientException {
        return left(OfflineFailure());
      } on TimeoutException {
        return left(OfflineFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
