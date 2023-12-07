import 'package:delivery_man_app/services/networking/api_requests.dart';
import '../../controllers/Client/client_controller.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/user_data_model.dart';

abstract class AuthApiService {
  Future<UserModel> postLoginApi(LoginModel loginModel);
}

class AuthApiServiceImpWithHttp implements AuthApiService {
  final HttpClientController clientController;

  AuthApiServiceImpWithHttp({required this.clientController});

  @override
  Future<UserModel> postLoginApi(LoginModel loginModel) async {
    clientController.reOpenClient();

    final response = await ApiRequests.postRequest<UserModel>(
      urlPath: 'users/login',
      token: '',
      client: clientController.client,
      body: loginModel.toJson(),
      fromJson: UserModel.fromJson,
      isForAuth: true,
    );
    return response;
  }
}
