import 'dart:convert';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import '../../controllers/Client/client_controller.dart';
import '../../controllers/Client/timer_service.dart';
import '../../models/Orders/change_status_model.dart';
import '../../models/Orders/list_order_model.dart';
import '../../models/Orders/unassign_order_tome_model.dart';
import '../../models/Orders/update_order_response_model.dart';

abstract class OrdersApiService {
  Future<ListOrderModel> getListOrderDataApi(
      {required String token, required String status, required int offset});
  Future<ListOrderModel> getMyOrdersDataApi(
      {required String token, required String status, required int offset});

  Future<List<dynamic>> getOrderStatusDataApi(
    String token,
  );

  Future<UpdateOrderResponseModel> getOrderDetailsApi({
    required String token,
    required int orderId,
  });

  Future<UnAssignToVehicleModel> postUnAssignToVehicleApi(
      {required String token, required int vehicleId});

  Future<AssignOrderToMeDataModel> postAssignOrderToMeApi({
    required String token,
    required int orderId,
    required bool? confirm,
  });

  Future<UnAssignOrderToMeDataModel> postUnAssignOrderToMeApi({
    required String token,
    required int orderId,
  });

  Future<ChangeStatusModel> postChangeStatusApi({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required String? note,
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

    final response = await ApiMethods.getRequest<ListOrderModel>(
        urlPath: 'orders?order_status=$status&limit=5&page=$offset',
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

    final response = await ApiMethods.getRequest<ListOrderModel>(
        urlPath: 'orders/my_orders?order_status=$status&limit=5&page=$offset',
        token: token,
        client: clientController.secondaryClient,
        timerService: timerService,
        isGlobalTimer: false,
        fromJson: ListOrderModel.fromJson);

    return response;
  }

  @override
  Future<List<dynamic>> getOrderStatusDataApi(String token) async {
    clientController.reOpenSecondaryClient();

    final response = await ApiMethods.getRequest<List<dynamic>>(
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

    final response = await ApiMethods.getRequest<UpdateOrderResponseModel>(
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

    final response = await ApiMethods.postRequest<UnAssignToVehicleModel>(
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
  Future<AssignOrderToMeDataModel> postAssignOrderToMeApi({
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

    final response = await ApiMethods.postRequest<AssignOrderToMeDataModel>(
        urlPath: 'orders/assign_to_me',
        token: token,
        client: clientController.client,
        timerService: timerService,
        isGlobalTimer: true,
        body: body,
        fromJson: AssignOrderToMeDataModel.fromJson);

    return response;
  }

  @override
  Future<ChangeStatusModel> postChangeStatusApi({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required String? note,
    required List<ProductModel>? returnedProducts,
  }) async {
    clientController.reOpenClient();

    Map<String, dynamic> changeStatusJson = {
      'order_id': orderId,
      'status': status,
      'received_amount': amount,
      'note': note,
      'returned_products': returnedProducts == null
          ? null
          : json.encode(
              List<dynamic>.from(returnedProducts.map((x) => x.toJson()))),
    };

    if (returnedProducts == null) {
      changeStatusJson.remove('returned_products');
    }

    if (amount == null) {
      changeStatusJson.remove('received_amount');
    }

    if (note == null) {
      changeStatusJson.remove('note');
    }
    final response = await ApiMethods.postRequest<ChangeStatusModel>(
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

    final response = await ApiMethods.postRequest<OrderDataModel>(
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
  Future<UnAssignOrderToMeDataModel> postUnAssignOrderToMeApi({
    required String token,
    required int orderId,
  }) async {
    clientController.reOpenClient();

    final response = await ApiMethods.postRequest<UnAssignOrderToMeDataModel>(
        urlPath: 'orders/unassign_from_me',
        token: token,
        client: clientController.client,
        timerService: timerService,
        isGlobalTimer: true,
        body: {
          'order_id': orderId,
        },
        fromJson: UnAssignOrderToMeDataModel.fromJson);

    return response;
  }
}
