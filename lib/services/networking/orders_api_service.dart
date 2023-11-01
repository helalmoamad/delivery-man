import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:flutter/material.dart';
import '../../controllers/Client/client_controller.dart';
import '../../models/Orders/list_order_model.dart';
import '../../shared/errors/exceptions.dart';
import 'api_constants.dart';
import 'package:http/http.dart' as http;

abstract class OrdersApiService {
  Future<ListOrderModel> getListOrderDataApi(
      {required String token, required String status, required int offset});
  Future<ListOrderModel> getMyOrdersDataApi(
      {required String token, required String status, required int offset});

  Future<List<dynamic>> getOrderStatusDataApi(
    String token,
  );

  Future<UnAssignToVehicleModel> postUnAssignToVehicleApi(
      {required String token, required int vehicleId});

  Future<AssignOrderToMeDataModel> postAssignOrderToMeApi(
      {required String token, required int orderId});

  Future<Unit> postChangeStatusApi(
      {required String token,
      required String status,
      required int orderId,
      required int? amount,
      required String? file});
}

class OrdersApiServiceImpWithHttp implements OrdersApiService {
  final HttpClientController clientController;

  OrdersApiServiceImpWithHttp({required this.clientController});

  @override
  Future<ListOrderModel> getListOrderDataApi(
      {required String token,
      required String status,
      required int offset}) async {
    clientController.reOpenClient();
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/orders/index?order_status=$status&limit=5&page=$offset');
    final response = await clientController.client.get(uri, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
    });
    debugPrint('1');
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      debugPrint('get Orders data success');
      final resposeData = ListOrderModel.fromJson(data);

      return resposeData;
    } else {
      debugPrint('3');
      throw ServerException();
    }
  }

  @override
  Future<ListOrderModel> getMyOrdersDataApi(
      {required String token,
      required String status,
      required int offset}) async {
    clientController.reOpenClient();
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/orders/my_orders?order_status=$status&limit=5&page=$offset');
    final response = await clientController.client.get(uri, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
    });
    debugPrint('1');
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      debugPrint('get My Orders data success');
      final resposeData = ListOrderModel.fromJson(data);

      return resposeData;
    } else {
      debugPrint('3');
      debugPrint('get My Orders data Failed');
      throw ServerException();
    }
  }

  @override
  Future<List<dynamic>> getOrderStatusDataApi(String token) async {
    clientController.reOpenClient();
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/orders/order_statuses');
    final response = await clientController.client.get(uri, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
    });
    debugPrint('1');
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      debugPrint(data.toString());
      debugPrint('get Order Status data success');

      return data;
    } else {
      debugPrint('3');
      debugPrint('get Order Status data Failed');
      throw ServerException();
    }
  }

  @override
  Future<UnAssignToVehicleModel> postUnAssignToVehicleApi(
      {required String token, required int vehicleId}) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/vehicle/unassign_user');
    final body = {
      'vehicle_id': vehicleId,
    };

    final response = await clientController.client
        .post(uri, body: json.encode(body), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
    });
    debugPrint('1');
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);

      debugPrint('UnAssignToVehicleModel Success');
      final UnAssignToVehicleModel responseData =
          UnAssignToVehicleModel.fromJson(data);
      return responseData;
    } else {
      debugPrint('3');
      debugPrint('UnAssignToVehicleModel Failed');
      throw ServerException();
    }
  }

  @override
  Future<AssignOrderToMeDataModel> postAssignOrderToMeApi(
      {required String token, required int orderId}) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/orders/assign_to_me');
    final body = {
      'order_id': orderId,
    };

    final response = await clientController.client
        .post(uri, body: json.encode(body), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
    });
    debugPrint('1');
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);

      debugPrint('AssignOrderToMe Success');
      final AssignOrderToMeDataModel responseData =
          AssignOrderToMeDataModel.fromJson(data);
      return responseData;
    } else {
      debugPrint('3');
      debugPrint('AssignOrderToMe Failed');
      throw ServerException();
    }
  }

  @override
  Future<Unit> postChangeStatusApi(
      {required String token,
      required String status,
      required int orderId,
      required int? amount,
      required String? file}) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/orders/change_status');

    var request = http.MultipartRequest('POST', uri);

    file == null
        ? null
        : request.files.add(await http.MultipartFile.fromPath('file', file));

    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.fields['status'] = status.toString();
    request.fields['order_id'] = orderId.toString();
    amount == null
        ? null
        : request.fields['received_amount'] = amount.toString();

    debugPrint('1');

    var response = await request.send();
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      // final res = await response.stream.transform(utf8.decoder).first;
      // final data = jsonDecode(res);
      debugPrint('AssignOrderToMe Success');
      // final ChangeStatusModle responseData = ChangeStatusModle.fromJson(data);
      return Future.value(unit);
    } else {
      debugPrint('3');
      debugPrint('AssignOrderToMe Failed');
      throw ServerException();
    }
  }
}
