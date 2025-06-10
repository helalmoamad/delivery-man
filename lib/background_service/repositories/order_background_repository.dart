import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:dartz/dartz.dart';
import '../../shared/errors/exceptions.dart';
import '../../shared/errors/failures.dart';
import '../network/order_network.dart';

class OrderBackGroundRepository {
  final OrderNetworkApi orderNetworkApi;
  final Connectivity connectivity;

  OrderBackGroundRepository({
    required this.orderNetworkApi,
    required this.connectivity,
  });

  Future<Either<FailureDelivery, Unit>> uploadFile({
    required String token,
    required int orderId,
    required String file,
  }) async {
    final check = await connectivity.checkConnectivity();
    if (!check.contains(ConnectivityResult.none)) {
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
