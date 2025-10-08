import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../controllers/Auth/auth_controller.dart';
import '../../models/Auth/login_model.dart';
import '../../shared/constants/color_constants.dart';
import '../../shared/widgets/app_buttons.dart';
import '../../shared/widgets/circle_indecator_widget.dart';
import '../../shared/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final formKey = GlobalKey<FormState>();
  final TextEditingController userNameKey = TextEditingController();
  final TextEditingController passKey = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "LoginPage");
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
        body: GetBuilder<AuthController>(builder: (_) {
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
                                image: AssetImage('assets/pictures/logo.png')),
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
              authController.isCircleShown
                  ? const CircleIndicatorWidget(
                      isBgWhite: false,
                    )
                  : Container()
            ],
          );
        }),
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
              textInputType: TextInputType.text,
              controller: userNameKey,
              hintText: 'Enter  User Name'.tr,
              labelText: 'User Name'.tr,
              validator: (value) {
                if (value.isEmpty) {
                  return 'User Name should not be empty'.tr;
                }
              },
              prefixIcon: null,
              suffixIcon: null,
            ),
            ///////
            SizedBox(
              height: ScreenSizeUtils.getHeightInPercent(context, 3),
            ),
            ////////////
            CustomTextField(
              textInputType: TextInputType.visiblePassword,
              controller: passKey,
              hintText: 'Enter  Password'.tr,
              labelText: 'Password'.tr,
              isObscure: authController.isObscure,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Password should not be empty'.tr;
                }
              },
              prefixIcon: null,
              suffixIcon: IconButton(
                icon: Icon(authController.isObscure
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  authController.changeIsObscure();
                },
              ),
            ),
            //////////////
            ///
            ///////
            SizedBox(
              height: ScreenSizeUtils.getHeightInPercent(context, 10),
            ),
            ////////////
            AppButton.normalButton(
              backgroundColor: AppColors.blackDark,
              title: 'LOGIN'.tr,
              onPress: () async {
                if (formKey.currentState!.validate()) {
                  final loginData = LoginModel(
                      username: userNameKey.text, password: passKey.text);
                  await authController.login(loginModel: loginData);
                }
              },
            ),
            ///////
            SizedBox(
              height: ScreenSizeUtils.getHeightInPercent(context, 10),
            ),

            // ////////////
          ],
        ),
      ),
    );
  }
}
