import 'package:dartz/dartz.dart';
import '../models/Orders/list_order_model.dart';
import '../services/networking/orders_api_service.dart';
import '../shared/errors/exceptions.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';

class OrdersRepository {
  final OrdersApiService ordersApiService;
  final NetworkInfo networkInfo;

  OrdersRepository({required this.ordersApiService, required this.networkInfo});

  Future<Either<Failure, ListOrderModel>> getListOrderData({
    required String token,
    required String status,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final orderDataResponse =
            await ordersApiService.getListOrderDataApi(token, status);
        return Right(orderDataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, List<dynamic>>> getOrderStatusData({
    required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final orderStatusDataResponse =
            await ordersApiService.getOrderStatusDataApi(token);
        return Right(orderStatusDataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
