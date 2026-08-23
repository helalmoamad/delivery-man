import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Auth/verify_otp_model.dart'
    show OtpVerificationResponse;
import '../../repositories/auth_repository.dart';
import '../../shared/errors/failures.dart';

class VerifyOtpProvider {
  final AuthRepository authRepository;

  VerifyOtpProvider(this.authRepository);

  Future<Either<FailureDelivery, OtpVerificationResponse>> call({
    required String mobilePhone,
    required String otpId,
    required String otp,
  }) async {
    return await authRepository.postVerifyOtp(
      mobilePhone: mobilePhone,
      otpId: otpId,
      otp: otp,
    );
  }
}
