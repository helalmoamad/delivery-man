import 'package:delivery_man_app/services/networking/api_requests.dart';
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
    clientController.reOpenClient();

    final response = await ApiRequests.postRequest<AssignToVehicleModel>(
        urlPath: 'vehicle/assign_to_user',
        token: token,
        client: clientController.client,
        body: {
          'vehicle_id': vehicleId,
        },
        fromJson: AssignToVehicleModel.fromJson);

    return response;
  }
}
