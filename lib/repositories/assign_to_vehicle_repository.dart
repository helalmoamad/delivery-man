import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/AssignToVehicle/assign_to_vehicle_model.dart';
import 'package:delivery_man_app/services/networking/assign_to_vehicle_api_service.dart';
import '../shared/errors/exceptions.dart';
import '../shared/errors/failures.dart';
import '../shared/network_info/network_info.dart';

class AssignToVehicleRepository {
  final AssignToVehicleService assignToVehicleService;
  final NetworkInfo networkInfo;

  AssignToVehicleRepository(
      {required this.assignToVehicleService, required this.networkInfo});

  Future<Either<Failure, AssignToVehicleModel>> assignToVehicle(
      {required String token, required int vehicleId}) async {
    if (await networkInfo.isConnected) {
      try {
        final dataResponse = await assignToVehicleService
            .postAssignToVehicleApi(token: token, vehicleId: vehicleId);
        return Right(dataResponse);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
