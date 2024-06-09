import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/app_buttons.dart';
import 'package:delivery_man_app/shared/widgets/app_dialogs.dart';
import 'package:delivery_man_app/shared/widgets/custom_app_bar.dart';
import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:delivery_man_app/views/DrawerPages/info_for_developer/components/info_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoForDeveloperPage extends StatelessWidget {
  InfoForDeveloperPage({super.key});
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(
                title: 'Info For Developer'.tr,
                button: AppButton.normalButton(
                    title: 'Delete All Data'.tr,
                    height: 40,
                    titleSize: 13,
                    backgroundColor: AppColors.darkGrey,
                    onPress: () async {
                      AppDialogs.showAppDialogWidget(
                        context: context,
                        title: 'Are you sure you want delete to all data ?'.tr,
                        actions: [
                          AppButton.normalButton(
                            title: 'Confirm'.tr,
                            shadow: false,
                            width:
                                ScreenSizeUtils.getWidthInPercent(context, 25),
                            height: 30,
                            titleColor: AppColors.white,
                            backgroundColor: AppColors.primaryDark,
                            onPress: () async {
                              await authController.removeAllRequestsInfo();
                              Get.back();
                            },
                          ),
                          ///////////////
                          AppButton.normalButton(
                              title: 'Back'.tr,
                              shadow: false,
                              width: ScreenSizeUtils.getWidthInPercent(
                                  context, 25),
                              backgroundColor: AppColors.white,
                              titleColor: AppColors.primaryDark,
                              height: 30,
                              onPress: () {
                                Get.back();
                              })
                        ],
                      );
                    })),
            body: GetBuilder<AuthController>(builder: (_) {
              final data = GlobalFunctions.getRequestsInfo();
              return data.isEmpty
                  ? const Center(
                      child: TextWidget(
                          text: 'No Data',
                          color: AppColors.blackDark,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                          maxline: 1),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: ListView.separated(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return InfoWidget(index: index);
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              })),
                    );
            })));
  }
}
