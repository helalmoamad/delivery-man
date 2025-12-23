import 'dart:convert';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/models/Orders/listDirectOrder.dart';
import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import 'package:flutter/material.dart';
import '../../controllers/Client/client_controller.dart';
import '../../controllers/Client/timer_service.dart';
import '../../models/Orders/change_status_model.dart';
import '../../models/Orders/list_order_model.dart';
import '../../models/Orders/update_order_response_model.dart';

abstract class OrdersApiService {
  Future<ListOrderModel> getListOrderDataApi(
      {required String token, required String status, required int offset});

  Future<ListOrderModel> getListReturnedOrderDataApi(
      {required String token, required String status, required int offset});

  Future<ListOrderModel> getMyOrdersDataApi(
      {required String token, required String status, required int offset});

  Future<MyOrdersResponse> getAllMyOrdersDataApi({required String token});

  Future<GetOrderForChat> getMyOrderDataForChatApi(
      {required String token, required String id, required int offset});
  Future<List<dynamic>> getOrderStatusDataApi(
    String token,
  );

  Future<UpdateOrderResponseModel> getOrderDetailsApi({
    required String token,
    required int orderId,
  });

  Future<UnAssignToVehicleModel> postUnAssignToVehicleApi(
      {required String token, required int vehicleId});

  Future<AssignUnAssignOrderToMeDataModel> postAssignOrderToMeApi({
    required String token,
    required int orderId,
    required bool? confirm,
  });

  Future<AssignUnAssignOrderToMeDataModel> postUnAssignOrderToMeApi({
    required String token,
    required int orderId,
    required String note,
    required bool? confirm,
  });

  Future<ChangeStatusModel> postChangeStatusApi({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required String? note,
    int? originalLocId,
    required List<ProductModel>? returnedProducts,
  });

  Future<OrderDataModel> postChangeOrderReceivedAmountApi({
    required String token,
    required int orderId,
    required double receivedAmount,
  });
}

class OrdersApiServiceImpWithHttp implements OrdersApiService {
  final HttpClientService clientController;
  final TimerService timerService;

  OrdersApiServiceImpWithHttp({
    required this.clientController,
    required this.timerService,
  });

  @override
  Future<ListOrderModel> getListOrderDataApi(
      {required String token,
      required String status,
      required int offset}) async {
    clientController.reOpenSecondaryClient();

    final response = await ApiMethodsDelivery.getRequest<ListOrderModel>(
        urlPath: 'orders?order_status=$status&limit=5&page=$offset',
        token: token,
        client: clientController.secondaryClient,
        timerService: timerService,
        isGlobalTimer: false,
        fromJson: ListOrderModel.fromJson);

    return response;
  }

  @override
  Future<ListOrderModel> getListReturnedOrderDataApi(
      {required String token,
      required String status,
      required int offset}) async {
    clientController.reOpenSecondaryClient();

    final response = await ApiMethodsDelivery.getRequest<ListOrderModel>(
        urlPath: 'orders/returns?limit=5&page=$offset',
        token: token,
        client: clientController.secondaryClient,
        timerService: timerService,
        isGlobalTimer: false,
        fromJson: ListOrderModel.fromJson);

    return response;
  }

  @override
  Future<ListOrderModel> getMyOrdersDataApi({
    required String token,
    required String status,
    required int offset,
  }) async {
    clientController.reOpenSecondaryClient();

    final response = await ApiMethodsDelivery.getRequest<ListOrderModel>(
        urlPath: 'orders/my_orders?order_status=$status&limit=5&page=$offset',
        token: token,
        client: clientController.secondaryClient,
        timerService: timerService,
        isGlobalTimer: false,
        fromJson: ListOrderModel.fromJson);

    return response;
  }

  @override
  Future<MyOrdersResponse> getAllMyOrdersDataApi({
    required String token,
  }) async {
    clientController.reOpenSecondaryClient();

    final response = await ApiMethodsDelivery.getRequest<MyOrdersResponse>(
        urlPath: 'orders/my_orders',
        token: token,
        client: clientController.secondaryClient,
        timerService: timerService,
        isGlobalTimer: false,
        fromJson: MyOrdersResponse.fromJson);
        
    debugPrint('All my orders data: ${response.toString()}');
    return response;
  }

  @override
  Future<GetOrderForChat> getMyOrderDataForChatApi({
    required String token,
    required String id,
    required int offset,
  }) async {
    clientController.reOpenSecondaryClient();

    final response = await ApiMethodsDelivery.getRequest<GetOrderForChat>(
        urlPath: 'orders/original_order_details/$id',
        token: token,
        client: clientController.secondaryClient,
        timerService: timerService,
        isGlobalTimer: false,
        fromJson: GetOrderForChat.fromJson);

    return response;
  }

  @override
  Future<List<dynamic>> getOrderStatusDataApi(String token) async {
    clientController.reOpenSecondaryClient();

    final response = await ApiMethodsDelivery.getRequest<List<dynamic>>(
      urlPath: 'orders/order_statuses',
      token: token,
      client: clientController.secondaryClient,
      timerService: timerService,
      isGlobalTimer: false,
      fromJson: null,
    );

    return response;
  }

  @override
  Future<UpdateOrderResponseModel> getOrderDetailsApi({
    required String token,
    required int orderId,
  }) async {
    clientController.reOpenSecondaryClient();

    final response =
        await ApiMethodsDelivery.getRequest<UpdateOrderResponseModel>(
      urlPath: 'orders/order_details/$orderId',
      token: token,
      client: clientController.secondaryClient,
      isGlobalTimer: false,
      timerService: timerService,
      fromJson: UpdateOrderResponseModel.fromJson,
    );

    return response;
  }

  @override
  Future<UnAssignToVehicleModel> postUnAssignToVehicleApi(
      {required String token, required int vehicleId}) async {
    clientController.reOpenClient();

    final response =
        await ApiMethodsDelivery.postRequest<UnAssignToVehicleModel>(
            urlPath: 'vehicle/unassign_user',
            token: token,
            client: clientController.client,
            timerService: timerService,
            isGlobalTimer: true,
            body: {
              'vehicle_id': vehicleId,
            },
            fromJson: UnAssignToVehicleModel.fromJson);

    return response;
  }

  @override
  Future<AssignUnAssignOrderToMeDataModel> postAssignOrderToMeApi({
    required String token,
    required int orderId,
    required bool? confirm,
  }) async {
    clientController.reOpenClient();

    Map<String, dynamic> body = {
      'order_id': orderId,
      'confirm': confirm,
    };

    if (confirm == null) {
      body.remove('confirm');
    }

    final response =
        await ApiMethodsDelivery.postRequest<AssignUnAssignOrderToMeDataModel>(
            urlPath: 'orders/assign_to_me',
            token: token,
            client: clientController.client,
            timerService: timerService,
            isGlobalTimer: true,
            body: body,
            fromJson: AssignUnAssignOrderToMeDataModel.fromJson);

    return response;
  }

  @override
  Future<ChangeStatusModel> postChangeStatusApi({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required String? note,
    int? originalLocId,
    required List<ProductModel>? returnedProducts,
  }) async {
    clientController.reOpenClient();

    Map<String, dynamic> changeStatusJson = {
      'order_id': orderId,
      'status': status,
      'received_amount': amount,
      'note': note,
      'original_location_id': originalLocId,
      'returned_products': returnedProducts == null
          ? null
          : json.encode(
              List<dynamic>.from(returnedProducts.map((x) => x.toJson()))),
    };

    if (returnedProducts == null) {
      changeStatusJson.remove('returned_products');
    }

    if (originalLocId == null) {
      changeStatusJson.remove('original_location_id');
    }

    if (amount == null) {
      changeStatusJson.remove('received_amount');
    }

    if (note == null) {
      changeStatusJson.remove('note');
    }
    final response = await ApiMethodsDelivery.postRequest<ChangeStatusModel>(
      urlPath: 'orders/change_status',
      token: token,
      client: clientController.client,
      timerService: timerService,
      isGlobalTimer: true,
      body: changeStatusJson,
      fromJson: ChangeStatusModel.fromJson,
    );

    return response;
  }

  @override
  Future<OrderDataModel> postChangeOrderReceivedAmountApi({
    required String token,
    required int orderId,
    required double receivedAmount,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethodsDelivery.postRequest<OrderDataModel>(
        urlPath: 'orders/receive_amount',
        token: token,
        client: clientController.client,
        timerService: timerService,
        isGlobalTimer: true,
        body: {
          "received_amount": receivedAmount,
          "order_id": orderId,
        },
        fromJson: OrderDataModel.fromJson);

    return response;
  }

  @override
  Future<AssignUnAssignOrderToMeDataModel> postUnAssignOrderToMeApi({
    required String token,
    required int orderId,
    required bool? confirm,
    required String note,
  }) async {
    clientController.reOpenClient();

    Map<String, dynamic> body = {
      'order_id': orderId,
      'unassign_note': note,
      'confirm': confirm,
    };

    if (confirm == null) {
      body.remove('confirm');
    }

    final response =
        await ApiMethodsDelivery.postRequest<AssignUnAssignOrderToMeDataModel>(
            urlPath: 'orders/unassign_from_me',
            token: token,
            client: clientController.client,
            timerService: timerService,
            isGlobalTimer: true,
            body: body,
            fromJson: AssignUnAssignOrderToMeDataModel.fromJson);

    return response;
  }
}
