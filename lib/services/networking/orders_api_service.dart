import 'dart:convert';
import 'package:flutter/material.dart';
import '../../controllers/Client/client_controller.dart';
import '../../models/Orders/list_order_model.dart';
import '../../shared/errors/exceptions.dart';
import 'api_constants.dart';

abstract class OrdersApiService {
  Future<ListOrderModel> getListOrderDataApi(
      {required String token, required String status, required int offset});

  Future<List<dynamic>> getOrderStatusDataApi(
    String token,
  );
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
        '${ApiConstants.baseUrl}/${ApiConstants.newVersion}/delivery_man/orders?order_status=$status&limit=5&offset=$offset');
    final response = await clientController.client.get(uri, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
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
  Future<List<dynamic>> getOrderStatusDataApi(String token) async {
    clientController.reOpenClient();
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/${ApiConstants.newVersion}/delivery_man/order_status');
    final response = await clientController.client.get(uri, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
      'Connection': 'keep-alive',
    });
    debugPrint('1');
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      print(data);
      debugPrint('get Order Status data success');

      return data;
    } else {
      debugPrint('3');
      debugPrint('get Order Status data Failed');
      throw ServerException();
    }
  }
}
