import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import '../models/AssignToVehicle/unassign_to_vehicle_model.dart';
import '../models/Orders/list_order_model.dart';
import '../services/networking/orders_api_service.dart';
import '../shared/errors/failures.dart';
import '../shared/handling_errors.dart/request_error_handling.dart';
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
      } catch (e) {
        return RequestErrorHandling.handle(
          exception: e,
        );
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
      } catch (e) {
        return RequestErrorHandling.handle(
          exception: e,
        );
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
      } catch (e) {
        return RequestErrorHandling.handle(
          exception: e,
        );
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
      } catch (e) {
        return RequestErrorHandling.handle(
          exception: e,
        );
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, AssignOrderToMeDataModel>> assignOrderToMe({
    required String token,
    required int orderId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final dataResponse = await ordersApiService.postAssignOrderToMeApi(
            token: token, orderId: orderId);
        return Right(dataResponse);
      } catch (e) {
        return RequestErrorHandling.handle(
          exception: e,
        );
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> changeStatus({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required List<ProductModel>? returnedProducts,
    required String? file,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await ordersApiService.postChangeStatusApi(
          token: token,
          orderId: orderId,
          file: file,
          status: status,
          returnedProducts: returnedProducts,
          amount: amount,
        );
        return const Right(unit);
      } catch (e) {
        return RequestErrorHandling.handle(
          exception: e,
        );
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, OrderModel>> changeOrderReceivedAmount({
    required String token,
    required int orderId,
    required double receivedAmount,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final dataResponse =
            await ordersApiService.postChangeOrderReceivedAmountApi(
          token: token,
          orderId: orderId,
          receivedAmount: receivedAmount,
        );
        return Right(dataResponse);
      } catch (e) {
        return RequestErrorHandling.handle(
          exception: e,
        );
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
