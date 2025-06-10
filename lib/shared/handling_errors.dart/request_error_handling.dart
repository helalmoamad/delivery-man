import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../network_info/network_info.dart';

class RequestErrorHandling {
  static Future<Either<FailureDelivery, T>> handle<T>({
    required Object exception,
    required bool isClientCloseFailure,
    required NetworkInfo networkInfo,
  }) async {
    if (exception is ServerException) {
      debugPrint('//// ServerException ///// \n $exception');
      return left(
        ServerFailure(),
      );
    } else if (exception is ClientException) {
      debugPrint('//// ClientException ///// \n $exception');
      if (await networkInfo.isConnected) {
        return isClientCloseFailure
            ? left(
                ClientCloseFailure(),
              )
            : left(
                UnExpectedFailure(),
              );
      } else {
        return left(
          OfflineFailure(),
        );
      }
    } else if (exception is CantAssignToVehicleException) {
      debugPrint('//// CantAssignToVehicleException ///// \n $exception');
      return left(
        CantAssignToVehicleFailure(),
      );
    } else if (exception is TimeoutException) {
      debugPrint('//// TimeoutException ///// \n $exception');
      return left(OfflineFailure());
    } else if (exception is WrongDataException) {
      debugPrint('//// WrongDataException ///// \n $exception');
      return left(
        WrongDataFailure(),
      );
    } else if (exception is OtpTryAgainException) {
      debugPrint('//// OtpTryAgainException ///// \n $exception');
      return left(
        OtpTryAgainFailure(),
      );
    } else {
      debugPrint('//// UnExpected ///// \n $exception');
      return Left(
        UnExpectedFailure(),
      );
    }
  }
}
