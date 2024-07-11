import 'dart:async';
import 'package:http/http.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../shared/errors/exceptions.dart';
import '../../shared/errors/failures.dart';
import '../../shared/network_info/network_info.dart';
import '../network/order_network.dart';

class OrderBackGroundRepository {
  final OrderNetworkApi orderNetworkApi;
  final InternetConnectionChecker internetConnectionChecker;

  OrderBackGroundRepository({
    required this.orderNetworkApi,
    required this.internetConnectionChecker,
  });

  Future<Either<Failure, Unit>> uploadFile({
    required String token,
    required int orderId,
    required String file,
  }) async {
    if (await NetworkInfoImpl(internetConnectionChecker).isConnected) {
      try {
        await orderNetworkApi.uploadFileApi(
          token: token,
          file: file,
          orderId: orderId,
        );
        return const Right(unit);
      } on ServerException {
        return left(ServerFailure());
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
