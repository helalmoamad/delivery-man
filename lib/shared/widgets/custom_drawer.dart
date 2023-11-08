import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/shared/constants/lang_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/Auth/auth_controller.dart';
import '../constants/color_constants.dart';
import '../helpers/screen_size_utils.dart';
import 'app_buttons.dart';
import 'app_dialogs.dart';

class CustomDrawer extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final OrdersController ordersController = Get.find<OrdersController>();
  CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/pictures/drawer_pg.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            accountName: TextWidget(
                text: GlobalFunctions.getName(),
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                maxline: 1),
            accountEmail: TextWidget(
                text: GlobalFunctions.getEmail(),
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.start,
                maxline: 1),
            currentAccountPicture: InkWell(
              onLongPress: () {
                Get.toNamed(Routes.infoForDeveloper);
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/pictures/logo.png"),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.primaryDark,
            ),
            title: TextWidget(
                text: 'Profile'.tr,
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () async {},
          ),
          ListTile(
            leading: const Icon(
              Icons.language_rounded,
              color: AppColors.primaryDark,
            ),
            title: TextWidget(
                text: 'App Language'.tr,
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () {
              _showLangModal();
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: AppColors.primaryDark,
            ),
            title: TextWidget(
                text: 'Logout'.tr,
                color: AppColors.blackDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () {
              AppDialogs.showAppDialogWidget(
                context: context,
                title: 'Are you sure to logout ?'.tr,
                actions: [
                  AppButton.normalButton(
                    title: 'Confirm'.tr,
                    shadow: false,
                    width: ScreenSizeUtils.getWidthInPercent(context, 25),
                    height: 30,
                    titleColor: AppColors.white,
                    backgroundColor: AppColors.primaryDark,
                    onPress: () async {
                      await authController.logOut();
                    },
                  ),
                  ///////////////
                  AppButton.normalButton(
                      title: 'Back'.tr,
                      shadow: false,
                      width: ScreenSizeUtils.getWidthInPercent(context, 25),
                      backgroundColor: AppColors.white,
                      titleColor: AppColors.primaryDark,
                      height: 30,
                      onPress: () {
                        Get.back();
                      })
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  //////////
  _showLangModal() {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.all(16),
      height: 220,
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
              text: 'Select a Language'.tr,
              color:
                  Get.isDarkMode ? AppColors.secondary : AppColors.primaryDark,
              fontSize: 14,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.start,
              maxline: 1),
          const SizedBox(height: 32),
          ListTile(
            leading: Image.asset(
              'assets/pictures/uk.png',
              fit: BoxFit.cover,
            ),
            title: TextWidget(
                text: "English".tr,
                color: Get.isDarkMode ? AppColors.grey : AppColors.darkGrey,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () async {
              await authController.changeLanguage(LangConstants.ene);
              Get.back();
              Get.back();
            },
            trailing: GlobalFunctions.getLanLocal() == LangConstants.ene
                ? const Icon(
                    Icons.check_box,
                    color: AppColors.darkGrey,
                  )
                : Container(
                    width: 0,
                  ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Image.asset(
              'assets/pictures/sy.png',
              fit: BoxFit.cover,
            ),
            title: TextWidget(
                text: "Arabic".tr,
                color: Get.isDarkMode ? AppColors.grey : AppColors.darkGrey,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                maxline: 1),
            onTap: () async {
              await authController.changeLanguage(LangConstants.ara);
              Get.back();
              Get.back();
            },
            trailing: GlobalFunctions.getLanLocal() == LangConstants.ara
                ? Icon(
                    Icons.check_box,
                    color: Get.isDarkMode ? AppColors.grey : AppColors.darkGrey,
                  )
                : Container(
                    width: 0,
                  ),
          ),
        ],
      ),
    ));
  }
}
