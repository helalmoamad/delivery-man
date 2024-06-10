import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

class RequestErrorHandling {
  static Either<Failure, T> handle<T>({
    required Object exception,
    required bool isClientCloseFailure,
  }) {
    if (exception is ServerException) {
      debugPrint('//// ServerException ///// \n $exception');
      return left(
        ServerFailure(),
      );
    } else if (exception is ClientException) {
      debugPrint('//// ClientException ///// \n $exception');
      return isClientCloseFailure
          ? left(
              ClientCloseFailure(),
            )
          : left(
              UnExpectedFailure(),
            );
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
    } else {
      debugPrint('//// UnExpected ///// \n $exception');
      return Left(
        UnExpectedFailure(),
      );
    }
  }
}
