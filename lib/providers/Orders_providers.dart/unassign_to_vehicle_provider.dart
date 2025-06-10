import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/AssignToVehicle/unassign_to_vehicle_model.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class UnAssignToVehicleProvider {
  final OrdersRepository ordersRepository;

  UnAssignToVehicleProvider(this.ordersRepository);

  Future<Either<FailureDelivery, UnAssignToVehicleModel>> call(
      {required String token, required int vehicleId}) async {
    return await ordersRepository.unAssignToVehicle(
        token: token, vehicleId: vehicleId);
  }
}
