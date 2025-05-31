import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Auth/chat_login_model.dart';
import '../../repositories/auth_repository.dart';
import '../../shared/errors/failures.dart';

class ChatLoginProvider {
  final AuthRepository authRepository;

  ChatLoginProvider(this.authRepository);

  Future<Either<Failure, ChatLoginModel>> call({
    required String mobilePhone,
    required String otpIdToken,
    required String name,
    required int originalUserId,
  }) async {
    return await authRepository.chatLoginApi(
      mobilePhone: mobilePhone,
      name: name,
      originalUserId: originalUserId,
      otpIdToken: otpIdToken,
    );
  }
}
