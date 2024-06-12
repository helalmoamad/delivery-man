import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/models/RequestInfo/request_info_model.dart';
import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import '../../controllers/Client/client_controller.dart';
import '../../controllers/Client/timer_service.dart';
import '../../models/Orders/list_order_model.dart';
import '../../models/Orders/update_order_response_model.dart';
import '../../shared/errors/exceptions.dart';
import 'api_config/api_constants.dart';
import 'package:http/http.dart' as http;

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
  });

  Future<Unit> postChangeStatusApi({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required List<ProductModel>? returnedProducts,
    required String? file,
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
  Future<AssignOrderToMeDataModel> postAssignOrderToMeApi(
      {required String token, required int orderId}) async {
    clientController.reOpenClient();

    final response = await ApiMethods.postRequest<AssignOrderToMeDataModel>(
        urlPath: 'orders/assign_to_me',
        token: token,
        client: clientController.client,
        timerService: timerService,
        isGlobalTimer: true,
        body: {
          'order_id': orderId,
        },
        fromJson: AssignOrderToMeDataModel.fromJson);

    return response;
  }

  @override
  Future<Unit> postChangeStatusApi({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required List<ProductModel>? returnedProducts,
    required String? file,
  }) async {
    clientController.reOpenClient();

    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/orders/change_status');

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    file == null
        ? null
        : request.files.add(await http.MultipartFile.fromPath('file', file));

    returnedProducts == null
        ? null
        : request.fields['returned_products'] = json.encode(
            List<dynamic>.from(returnedProducts.map((x) => x.toJson())));

    request.fields['status'] = status.toString();
    request.fields['order_id'] = orderId.toString();
    amount == null
        ? null
        : request.fields['received_amount'] = amount.toString();

    debugPrint('1');

    var response = await request.send().timeout(const Duration(seconds: 30));
    debugPrint(response.statusCode.toString());
    final res = await response.stream.transform(utf8.decoder).first;
    /////////////////store request info//////////////////////////////////
    final data = RequestInfoModel(
        url: uri.toString(),
        requestType: 'POST',
        token: token,
        header: response.headers.toString(),
        body: request.fields.toString(),
        response: res.toString());

    await GlobalFunctions.setRequestInfo(requestInfo: data);
    //////////////////////////////////////////////////////////////////
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      //
      // final data = jsonDecode(res);
      debugPrint('ChangeStatus Success');
      // final ChangeStatusModle responseData = ChangeStatusModle.fromJson(data);
      return Future.value(unit);
    } else {
      debugPrint('3');
      debugPrint(res.toString());
      debugPrint('ChangeStatus Failed');
      throw ServerException();
    }
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
}
