import 'package:dartz/dartz.dart';
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

  Future<Either<Failure, UserDataModel>> postLogin(
      LoginModel loginModel) async {
    if (await networkInfo.isConnected) {
      try {
        final authResponse = await authApiService.postLoginApi(loginModel);
        return Right(authResponse);
      } on ServerException {
        return left(ServerFailure());
      } on WrongDataException {
        return left(WrongDataFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
