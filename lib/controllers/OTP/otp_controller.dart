import 'dart:async';
import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  var secondsRemaining = 120.obs;
  late Timer _timer;
  var isResendAvailable = false.obs;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    secondsRemaining.value = 120;
    isResendAvailable.value = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          _timer.cancel();
          isResendAvailable.value = true;
        }
      },
    );
  }

  final AuthController authController = Get.find<AuthController>();
  void resendCode() async {
    debugPrint("Resending OTP...");
    startTimer();
    // `mobilePhone` is only written after a successful login, so on a first
    // sign-in the resend has to reuse the number the OTP was requested for.
    await authController.sendOtp(
      phone: GlobalFunctions.getOtpMobilePhone() ??
          GlobalFunctions.getMobilePhone(),
      isViaWhatsapp: 1,
    );
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
