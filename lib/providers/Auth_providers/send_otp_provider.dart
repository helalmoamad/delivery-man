import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Auth/send_otp_model.dart';
import '../../repositories/auth_repository.dart';
import '../../shared/errors/failures.dart';

class SendOtpProvider {
  final AuthRepository authRepository;

  SendOtpProvider(this.authRepository);

  Future<Either<FailureDelivery, OtpResponse>> call({
    required String phone,
    required int isViaWhatsapp,
  }) async {
    return await authRepository.postsendOtp(
      phone: phone,
      isViaWhatsapp: isViaWhatsapp,
    );
  }
}
