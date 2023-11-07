import 'package:dartz/dartz.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/user_data_model.dart';
import '../../repositories/auth_repository.dart';
import '../../shared/errors/failures.dart';

class LoginProvider {
  final AuthRepository authRepository;

  LoginProvider(this.authRepository);

  Future<Either<Failure, UserModel>> call(LoginModel loginModel) async {
    return await authRepository.postLogin(loginModel);
  }
}
