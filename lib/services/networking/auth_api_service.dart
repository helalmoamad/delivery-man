import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../controllers/Client/client_controller.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/user_data_model.dart';
import '../../shared/errors/exceptions.dart';
import 'api_constants.dart';

abstract class AuthApiService {
  Future<UserDataModel> postLoginApi(LoginModel loginModel);
}

class AuthApiServiceImpWithHttp implements AuthApiService {
  final HttpClientController clientController;

  AuthApiServiceImpWithHttp({required this.clientController});

  @override
  Future<UserDataModel> postLoginApi(LoginModel loginModel) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl2}/api/${ApiConstants.version2}/users/login');
    final body = loginModel.toJson();
    final response = await clientController.client
        .post(uri, body: json.encode(body), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Connection': 'keep-alive',
    });
    debugPrint('1');
    debugPrint(response.statusCode.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      if (data['isSuccessful'] == true) {
        debugPrint('logIn Success');
        final UserDataModel responseData = UserDataModel.fromJson(data['data']);
        return responseData;
      } else {
        debugPrint('3');
        debugPrint('wrong entry data');
        throw WrongDataException();
      }
    } else {
      debugPrint('4');
      debugPrint('logIn Failed');
      throw ServerException();
    }
  }
}
