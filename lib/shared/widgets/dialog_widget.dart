import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';
import '../helpers/screen_size_utils.dart';
import 'app_buttons.dart';

class DialogWidget {
  static void showDialogWidget(
      {required BuildContext context,
      required String title,
      required Function() onConfirm}) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        color: AppColors.primaryDark,
        fontSize: ScreenSizeUtils.getSp(context, 15),
      ),
      middleText: '',
      radius: 5,
      backgroundColor: AppColors.lightGray,
      actions: [
        AppButton.normalButton(
          title: 'Confirm'.tr,
          shadow: false,
          width: ScreenSizeUtils.getWidthInPercent(context, 25),
          height: 30,
          titleColor: AppColors.white,
          backgroundColor: AppColors.primaryDark,
          onPress: onConfirm,
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
  }
}
