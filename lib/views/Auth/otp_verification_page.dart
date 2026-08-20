import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/controllers/OTP/otp_controller.dart';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/constants/failure_messages.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:delivery_man_app/shared/widgets/snackbar_widgets.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart'
    show TextWidget;
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart'
    show OtpTextField;
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final OtpController otpController = Get.find<OtpController>();
  final AuthController authController = Get.find<AuthController>();
  bool _isLoading = true;

  @override
  void initState() {
    PagesMonitor.addPageToList(page: "OtpVerificationPage");
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      final log = await DeviceInfoHelper.createErrorLog(
          errorType: "Flutter Error",
          lastFourPageVisited: lastFourPageVisited,
          errorPath: lastFourPageVisited.last ?? "",
          lastApiRequest: '');
      await errorSender.sendError(log);
      await Sentry.captureException(details.exception,
          stackTrace: details.stack);
    };
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Scaffold(
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text("Please wait...")
                    ],
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                      ///
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
                                verificationId:
                                    GlobalFunctions.getVerificationId()!,
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
