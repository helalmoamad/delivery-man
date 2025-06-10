import 'package:dartz/dartz.dart';
import '../../repositories/auth_repository.dart';
import '../../shared/errors/failures.dart';

class LogOutProvider {
  final AuthRepository authRepository;

  LogOutProvider(this.authRepository);

  Future<Either<FailureDelivery, Unit>> call({required String token}) async {
    return await authRepository.postLogout(token: token);
  }
}
