import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/controllers/OTP/otp_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/constants/failure_messages.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';

import 'package:delivery_man_app/shared/widgets/snackbar_widgets.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart'
    show TextWidget;
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart'
    show OtpTextField;
import 'package:get/get.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final OtpController otpController = Get.find<OtpController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Phone Verification".tr,
                  color: AppColors.blackDark,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  maxline: 1,
                ),
                /////////////////////////////
                SizedBox(
                  height: ScreenSizeUtils.getHeightInPercent(context, 3),
                ),
                /////////////////////////////
                TextWidget(
                  text: "We sent to you a code please enter it".tr,
                  color: AppColors.blackDark,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                  maxline: 2,
                ),
                /////////////////////////////
                SizedBox(
                  height: ScreenSizeUtils.getHeightInPercent(context, 20),
                ),
                /////////////////////////////
                Obx(
                  () {
                    return Center(
                      child: TextWidget(
                        text: otpController.isResendAvailable.value
                            ? "Didn't receive the code?".tr
                            : "${'Resend code in'.tr} ${otpController.secondsRemaining.value}${'second'.tr}",
                        color: AppColors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                        maxline: 1,
                      ),
                    );
                  },
                ),
                /////////
                Obx(
                  () {
                    return otpController.isResendAvailable.value
                        ? Center(
                            child: TextButton(
                              onPressed: otpController.resendCode,
                              child: TextWidget(
                                text: 'Resend Code'.tr,
                                color: AppColors.primaryDark,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.start,
                                maxline: 1,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                /////////////////////////////
                SizedBox(
                  height: ScreenSizeUtils.getHeightInPercent(context, 5),
                ),
                /////////////////////////////
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: AppColors.primaryDark,
                  enabledBorderColor: AppColors.primaryDark,
                  focusedBorderColor: AppColors.blackDark,
                  showFieldAsBox: true,
                  autoFocus: true,
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  onSubmit: (String verificationCode) async {
                    if (otpController.isResendAvailable.value) {
                      SnackBarWidgets.showFailureSnackBar(
                        'Please resend the code'.tr,
                        seconds: 4,
                        '',
                      );
                    } else {
                      if (GlobalFunctions.getVerificationId() != null) {
                        await authController.verifyOtp(
                          otp: verificationCode,
                          verificationId: GlobalFunctions.getVerificationId()!,
                        );
                      } else {
                        SnackBarWidgets.showFailureSnackBar(
                          AppFailureMessages.unExpectedFailureMessage,
                          seconds: 4,
                          '',
                        );
                      }
                    }
                  }, // end onSubmit
                ),
                /////////////////////////////
                SizedBox(
                  height: ScreenSizeUtils.getHeightInPercent(context, 10),
                ),
                ////////////
                GetBuilder<AuthController>(
                  builder: (_) {
                    return (authController.isVerifyOtpCircleShown ||
                            authController.isChatLoginCircleShown)
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
