import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import '../models/AssignToVehicle/unassign_to_vehicle_model.dart';
import '../models/Orders/list_order_model.dart';
import '../services/networking/orders_api_service.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';
import 'repo_network_request.dart';

class OrdersRepository {
  final OrdersApiService ordersApiService;
  final NetworkInfo networkInfo;

  OrdersRepository({required this.ordersApiService, required this.networkInfo});

  Future<Either<Failure, ListOrderModel>> getListOrderData(
      {required String token,
      required String status,
      required int offset}) async {
    return RepoNetworkRequest.makeNetworkRequest<ListOrderModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.getListOrderDataApi(
          token: token, status: status, offset: offset),
    );
  }

  Future<Either<Failure, ListOrderModel>> getMyOrdersData(
      {required String token,
      required String status,
      required int offset}) async {
    return RepoNetworkRequest.makeNetworkRequest<ListOrderModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.getMyOrdersDataApi(
          token: token, status: status, offset: offset),
    );
  }

  Future<Either<Failure, List<dynamic>>> getOrderStatusData({
    required String token,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<List<dynamic>>(
      networkInfo: networkInfo,
      request: () => ordersApiService.getOrderStatusDataApi(token),
    );
  }

  Future<Either<Failure, UnAssignToVehicleModel>> unAssignToVehicle(
      {required String token, required int vehicleId}) async {
    return RepoNetworkRequest.makeNetworkRequest<UnAssignToVehicleModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.postUnAssignToVehicleApi(
          token: token, vehicleId: vehicleId),
    );
  }

  Future<Either<Failure, AssignOrderToMeDataModel>> assignOrderToMe({
    required String token,
    required int orderId,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<AssignOrderToMeDataModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.postAssignOrderToMeApi(
          token: token, orderId: orderId),
    );
  }

  Future<Either<Failure, Unit>> changeStatus({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required List<ProductModel>? returnedProducts,
    required String? file,
  }) async {
    return RepoNetworkRequest.makeNetworkRequestUnit(
      networkInfo: networkInfo,
      request: () => ordersApiService.postChangeStatusApi(
        token: token,
        orderId: orderId,
        file: file,
        status: status,
        returnedProducts: returnedProducts,
        amount: amount,
      ),
    );
  }

  Future<Either<Failure, OrderModel>> changeOrderReceivedAmount({
    required String token,
    required int orderId,
    required double receivedAmount,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<OrderModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.postChangeOrderReceivedAmountApi(
        token: token,
        orderId: orderId,
        receivedAmount: receivedAmount,
      ),
    );
  }
}
