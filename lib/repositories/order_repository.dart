import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import '../models/AssignToVehicle/unassign_to_vehicle_model.dart';
import '../models/Orders/list_order_model.dart';
import '../services/networking/orders_api_service.dart';
import '../shared/errors/exceptions.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';

class OrdersRepository {
  final OrdersApiService ordersApiService;
  final NetworkInfo networkInfo;

  OrdersRepository({required this.ordersApiService, required this.networkInfo});

  Future<Either<Failure, ListOrderModel>> getListOrderData(
      {required String token,
      required String status,
      required int offset}) async {
    if (await networkInfo.isConnected) {
      try {
        final orderDataResponse = await ordersApiService.getListOrderDataApi(
            token: token, status: status, offset: offset);
        return Right(orderDataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, ListOrderModel>> getMyOrdersData(
      {required String token,
      required String status,
      required int offset}) async {
    if (await networkInfo.isConnected) {
      try {
        final orderDataResponse = await ordersApiService.getMyOrdersDataApi(
            token: token, status: status, offset: offset);
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

  Future<Either<Failure, UnAssignToVehicleModel>> unAssignToVehicle(
      {required String token, required int vehicleId}) async {
    if (await networkInfo.isConnected) {
      try {
        final dataResponse = await ordersApiService.postUnAssignToVehicleApi(
            token: token, vehicleId: vehicleId);
        return Right(dataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, AssignOrderToMeDataModel>> assignOrderToMe(
      {required String token, required int orderId}) async {
    if (await networkInfo.isConnected) {
      try {
        final dataResponse = await ordersApiService.postAssignOrderToMeApi(
            token: token, orderId: orderId);
        return Right(dataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> changeStatus(
      {required String token,
      required String status,
      required int orderId,
      required int amount,
      required String? file}) async {
    if (await networkInfo.isConnected) {
      try {
        // final dataResponse =
        await ordersApiService.postChangeStatusApi(
            token: token,
            orderId: orderId,
            file: file,
            status: status,
            amount: amount);
        return const Right(unit);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
