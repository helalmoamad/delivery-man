import 'package:dartz/dartz.dart';
import '../../models/Auth/fcm_token_model.dart';
import '../../repositories/auth_repository.dart';
import '../../shared/errors/failures.dart';

class SetFcmTokenProvider {
  final AuthRepository authRepository;

  SetFcmTokenProvider(this.authRepository);

  Future<Either<Failure, SetFcmTokenModel>> call({
    required String token,
    required String fcmToken,
  }) async {
    return await authRepository.setFcmToken(fcmToken: fcmToken, token: token);
  }
}
