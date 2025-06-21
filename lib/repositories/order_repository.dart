import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import '../models/AssignToVehicle/unassign_to_vehicle_model.dart';
import '../models/Orders/list_order_model.dart';
import '../models/Orders/update_order_response_model.dart';
import '../services/networking/orders_api_service.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';
import 'repo_network_request.dart';

class OrdersRepository {
  final OrdersApiService ordersApiService;
  final NetworkInfo networkInfo;

  OrdersRepository({required this.ordersApiService, required this.networkInfo});

  Future<Either<FailureDelivery, ListOrderModel>> getListOrderData(
      {required String token,
      required String status,
      required int offset}) async {
    return RepoNetworkRequest.makeNetworkRequest<ListOrderModel>(
      networkInfo: networkInfo,
      isClientCloseFailure: true,
      request: () => ordersApiService.getListOrderDataApi(
        token: token,
        status: status,
        offset: offset,
      ),
    );
  }

  Future<Either<FailureDelivery, ListOrderModel>> getMyOrdersData(
      {required String token,
      required String status,
      required int offset}) async {
    return RepoNetworkRequest.makeNetworkRequest<ListOrderModel>(
      networkInfo: networkInfo,
      isClientCloseFailure: true,
      request: () => ordersApiService.getMyOrdersDataApi(
          token: token, status: status, offset: offset),
    );
  }

  Future<Either<FailureDelivery, GetOrderForChat>> getMyOrderDataForChatApi(
      {required String token, required String id, required int offset}) async {
    return RepoNetworkRequest.makeNetworkRequest<GetOrderForChat>(
      networkInfo: networkInfo,
      isClientCloseFailure: true,
      request: () => ordersApiService.getMyOrderDataForChatApi(
          token: token, id: id, offset: offset),
    );
  }

  Future<Either<FailureDelivery, List<dynamic>>> getOrderStatusData({
    required String token,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<List<dynamic>>(
      networkInfo: networkInfo,
      isClientCloseFailure: true,
      request: () => ordersApiService.getOrderStatusDataApi(token),
    );
  }

  Future<Either<FailureDelivery, UpdateOrderResponseModel>> getOrderDetails({
    required String token,
    required int orderId,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<UpdateOrderResponseModel>(
      networkInfo: networkInfo,
      isClientCloseFailure: true,
      request: () => ordersApiService.getOrderDetailsApi(
        token: token,
        orderId: orderId,
      ),
    );
  }

  Future<Either<FailureDelivery, UnAssignToVehicleModel>> unAssignToVehicle(
      {required String token, required int vehicleId}) async {
    return RepoNetworkRequest.makeNetworkRequest<UnAssignToVehicleModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.postUnAssignToVehicleApi(
          token: token, vehicleId: vehicleId),
    );
  }

  Future<Either<FailureDelivery, AssignUnAssignOrderToMeDataModel>>
      assignOrderToMe({
    required String token,
    required int orderId,
    required bool? confirm,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<
        AssignUnAssignOrderToMeDataModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.postAssignOrderToMeApi(
        token: token,
        orderId: orderId,
        confirm: confirm,
      ),
    );
  }

  Future<Either<FailureDelivery, AssignUnAssignOrderToMeDataModel>>
      unAssignOrderToMe({
    required String token,
    required int orderId,
    required String note,
    required bool? confirm,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<
        AssignUnAssignOrderToMeDataModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.postUnAssignOrderToMeApi(
        token: token,
        orderId: orderId,
        note: note,
        confirm: confirm,
      ),
    );
  }

  Future<Either<FailureDelivery, Unit>> changeStatus({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required String? note,
    required List<ProductModel>? returnedProducts,
  }) async {
    return RepoNetworkRequest.makeNetworkRequestUnit(
      networkInfo: networkInfo,
      isClientCloseFailure: true,
      request: () => ordersApiService.postChangeStatusApi(
        token: token,
        orderId: orderId,
        status: status,
        returnedProducts: returnedProducts,
        note: note,
        amount: amount,
      ),
    );
  }

  Future<Either<FailureDelivery, OrderDataModel>> changeOrderReceivedAmount({
    required String token,
    required int orderId,
    required double receivedAmount,
  }) async {
    return RepoNetworkRequest.makeNetworkRequest<OrderDataModel>(
      networkInfo: networkInfo,
      request: () => ordersApiService.postChangeOrderReceivedAmountApi(
        token: token,
        orderId: orderId,
        receivedAmount: receivedAmount,
      ),
    );
  }
}
