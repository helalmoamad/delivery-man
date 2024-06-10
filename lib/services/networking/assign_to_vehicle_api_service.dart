import 'package:delivery_man_app/controllers/Client/timer_service.dart';
import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import '../../controllers/Client/client_controller.dart';
import '../../models/AssignToVehicle/assign_to_vehicle_model.dart';

abstract class AssignToVehicleService {
  Future<AssignToVehicleModel> postAssignToVehicleApi(
      {required String token, required int vehicleId});
}

class AssignToVehicleServiceImpWithHttp implements AssignToVehicleService {
  final HttpClientService clientController;
  final TimerService timerService;

  AssignToVehicleServiceImpWithHttp({
    required this.clientController,
    required this.timerService,
  });

  @override
  Future<AssignToVehicleModel> postAssignToVehicleApi(
      {required String token, required int vehicleId}) async {
    clientController.reOpenClient();

    final response = await ApiMethods.postRequest<AssignToVehicleModel>(
        urlPath: 'vehicle/assign_to_user',
        token: token,
        client: clientController.client,
        timerService: timerService,
        isGlobalTimer: true,
        body: {
          'vehicle_id': vehicleId,
        },
        fromJson: AssignToVehicleModel.fromJson);

    return response;
  }
}
