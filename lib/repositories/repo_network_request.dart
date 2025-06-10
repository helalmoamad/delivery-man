import 'package:dartz/dartz.dart';
import '../shared/errors/failures.dart';
import '../shared/handling_errors.dart/request_error_handling.dart';
import '../shared/network_info/network_info.dart';

class RepoNetworkRequest {
  static Future<Either<FailureDelivery, T>> makeNetworkRequest<T>({
    required Future<T> Function() request,
    required NetworkInfo networkInfo,
    bool isClientCloseFailure = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await request();
        return Right(response);
      } catch (e) {
        return await RequestErrorHandling.handle(
            exception: e,
            networkInfo: networkInfo,
            isClientCloseFailure: isClientCloseFailure);
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  static Future<Either<FailureDelivery, Unit>> makeNetworkRequestUnit({
    required Future<void> Function() request,
    required NetworkInfo networkInfo,
    bool isClientCloseFailure = false,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await request();
        return const Right(unit);
      } catch (e) {
        return await RequestErrorHandling.handle(
            exception: e,
            networkInfo: networkInfo,
            isClientCloseFailure: isClientCloseFailure);
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
