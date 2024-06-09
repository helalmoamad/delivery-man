import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/AssignToVehicle/assign_to_vehicle_model.dart';
import 'package:delivery_man_app/services/networking/assign_to_vehicle_api_service.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';
import 'repo_network_request.dart';

class AssignToVehicleRepository {
  final AssignToVehicleService assignToVehicleService;
  final NetworkInfo networkInfo;

  AssignToVehicleRepository(
      {required this.assignToVehicleService, required this.networkInfo});

  Future<Either<Failure, AssignToVehicleModel>> assignToVehicle(
      {required String token, required int vehicleId}) async {
    return RepoNetworkRequest.makeNetworkRequest<AssignToVehicleModel>(
      networkInfo: networkInfo,
      request: () => assignToVehicleService.postAssignToVehicleApi(
          token: token, vehicleId: vehicleId),
    );
  }
}
