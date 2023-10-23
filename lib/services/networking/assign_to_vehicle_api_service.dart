import 'dart:convert';
import 'package:delivery_man_app/services/networking/api_constants.dart';
import 'package:delivery_man_app/shared/errors/exceptions.dart';
import 'package:flutter/material.dart';
import '../../controllers/Client/client_controller.dart';
import '../../models/AssignToVehicle/assign_to_vehicle_model.dart';

abstract class AssignToVehicleService {
  Future<AssignToVehicleModel> postAssignToVehicleApi(
      {required String token, required int vehicleId});
}

class AssignToVehicleServiceImpWithHttp implements AssignToVehicleService {
  final HttpClientController clientController;

  AssignToVehicleServiceImpWithHttp({required this.clientController});

  @override
  Future<AssignToVehicleModel> postAssignToVehicleApi(
      {required String token, required int vehicleId}) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl2}/api/${ApiConstants.version2}/vehicle/assign_to_user');
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

      debugPrint('AssignToVehicle Success');
      final AssignToVehicleModel responseData =
          AssignToVehicleModel.fromJson(data);
      return responseData;
    } else {
      debugPrint('3');
      debugPrint('AssignToVehicle Failed');
      throw ServerException();
    }
  }
}
