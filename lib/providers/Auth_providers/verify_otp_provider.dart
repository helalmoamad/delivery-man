import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Auth/verify_otp_model.dart'
    show VerifyOtpResponseModel;
import '../../repositories/auth_repository.dart';
import '../../shared/errors/failures.dart';

class VerifyOtpProvider {
  final AuthRepository authRepository;

  VerifyOtpProvider(this.authRepository);

  Future<Either<FailureDelivery, VerifyOtpResponseModel>> call({
    required String verificationId,
    required String otp,
  }) async {
    return await authRepository.postVerifyOtp(
      verificationId: verificationId,
      otp: otp,
    );
  }
}
