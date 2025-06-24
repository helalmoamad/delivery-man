import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseOtpMethod extends StatelessWidget {
  ChooseOtpMethod({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: ScreenSizeUtils.getHeightInPercent(context, 5),
              ),
              //////////////////////
              Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/pictures/logo.png')),
                  )),
              /////////////////////
              SizedBox(
                height: ScreenSizeUtils.getHeightInPercent(context, 5),
              ),
              //////////////////////
              TextWidget(
                text: 'Verification Methods'.tr,
                color: AppColors.blackDark,
                fontSize: 23,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                maxline: 2,
              ),
              /////////////////////
              SizedBox(
                height: ScreenSizeUtils.getHeightInPercent(context, 20),
              ),
              /////////////////////
              //////////////////////
              buildBody(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenSizeUtils.getWidthInPercent(context, 5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GetBuilder<AuthController>(
            builder: (_) {
              return Row(
                children: [
                  Expanded(
                    child: AppButton.normalButton(
                      backgroundColor: authController.otpMethod == 'whatsapp'
                          ? Colors.green
                          : AppColors.grey,
                      titleSize: 15,
                      title: 'Whatsapp'.tr,
                      onPress: () {
                        authController.chooseOtpMethod(method: 'whatsapp');
                      },
                    ),
                  ),
                  //////////////////
                  const SizedBox(
                    width: 5,
                  ),
                  //////////////////
                  Expanded(
                    child: AppButton.normalButton(
                      backgroundColor: authController.otpMethod == 'sms'
                          ? Colors.green
                          : AppColors.grey,
                      titleSize: 15,
                      title: 'SMS'.tr,
                      onPress: () {
                        authController.chooseOtpMethod(method: 'sms');
                      },
                    ),
                  ),
                ],
              );
            },
          ),

          ///////
          SizedBox(
            height: ScreenSizeUtils.getHeightInPercent(context, 5),
          ),
          ////////////
          AppButton.normalButton(
            backgroundColor: AppColors.blackDark,
            titleSize: 15,
            title: 'Confirm'.tr,
            onPress: () async {
              Get.toNamed(Routes.otpVerificationPage);
              ////////////////////////////////////////////////////
              await authController.sendOtp(
                phone: authController.countryCode +
                    authController.currentPhoneNumber,
                isViaWhatsapp: authController.otpMethod == 'whatsapp' ? 1 : 0,
              );
            },
          ),
          ///////
          SizedBox(
            height: ScreenSizeUtils.getHeightInPercent(context, 10),
          ),
        ],
      ),
    );
  }
}
