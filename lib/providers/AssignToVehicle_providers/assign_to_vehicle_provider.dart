import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/AssignToVehicle/assign_to_vehicle_model.dart';
import 'package:delivery_man_app/repositories/assign_to_vehicle_repository.dart';
import '../../shared/errors/failures.dart';

class AssignToVehicleProvider {
  final AssignToVehicleRepository assignToVehicleRepository;

  AssignToVehicleProvider(this.assignToVehicleRepository);

  Future<Either<FailureDelivery, AssignToVehicleModel>> call(
      {required String token, required int vehicleId}) async {
    return await assignToVehicleRepository.assignToVehicle(
        token: token, vehicleId: vehicleId);
  }
}
