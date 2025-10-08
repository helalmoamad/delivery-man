import 'package:country_code_picker/country_code_picker.dart';
import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/circle_indecator_widget.dart';
import 'package:delivery_man_app/shared/widgets/custom_text_field.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class InsertNumberPage extends StatelessWidget {
  InsertNumberPage({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController numberKey = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "InsertNumberPage");
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
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<AuthController>(
          builder: (_) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenSizeUtils.getHeightInPercent(context, 5),
                      ),
                      //////////////////////
                      InkWell(
                        onLongPress: () {
                          Get.toNamed(Routes.infoForDeveloper);
                        },
                        child: Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/pictures/logo.png')),
                            )),
                      ),
                      /////////////////////
                      SizedBox(
                        height: ScreenSizeUtils.getHeightInPercent(context, 5),
                      ),
                      //////////////////////
                      TextWidget(
                          text: 'Login'.tr,
                          color: AppColors.blackDark,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                          maxline: 1),
                      /////////////////////
                      SizedBox(
                        height: ScreenSizeUtils.getHeightInPercent(context, 15),
                      ),
                      //////////////////////
                      buildBody(context)
                    ],
                  ),
                ),
                ///////////
                ///////////
                authController.isCircleShown
                    ? const CircleIndicatorWidget(
                        isBgWhite: false,
                      )
                    : Container()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenSizeUtils.getWidthInPercent(context, 5)),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextField(
              textInputType: TextInputType.phone,
              controller: numberKey,
              hintText: 'Enter Phone Number'.tr,
              labelText: 'Phone Number'.tr,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone Number should not be empty'.tr;
                }
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return 'Phone number must contain only digits';
                }
                if (value.length <= 8) {
                  return 'Phone number must be more than 8 digits';
                }
                return null;
              },
              prefixIcon: null,
              suffixIcon: Directionality(
                textDirection: TextDirection.ltr,
                child: CountryCodePicker(
                  onChanged: (value) {
                    authController.countryCode = value.dialCode!;
                  },
                  initialSelection: 'SY',
                  favorite: const ['+963', 'SY', '+971', 'AE'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
              ),
            ),
            ///////
            SizedBox(
              height: ScreenSizeUtils.getHeightInPercent(context, 10),
            ),
            ////////////
            AppButton.normalButton(
              backgroundColor: AppColors.blackDark,
              titleSize: 15,
              title: 'Confirm'.tr,
              onPress: () {
                if (formKey.currentState!.validate()) {
                  authController.currentPhoneNumber = numberKey.text;
                  /////////////////////
                  Get.toNamed(Routes.chooseOtpMethod);
                }
              },
            ),
            ///////
            SizedBox(
              height: ScreenSizeUtils.getHeightInPercent(context, 10),
            ),
          ],
        ),
      ),
    );
  }
}
