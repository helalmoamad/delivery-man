import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';
import '../helpers/screen_size_utils.dart';

class AppDialogs {
  static void showAppDialogWidget({
    required BuildContext context,
    required String title,
    required List<Widget> actions,
    // required Function() onConfirm
  }) {
    Get.defaultDialog(
        title: title,
        titleStyle: TextStyle(
          color: AppColors.primaryDark,
          fontSize: ScreenSizeUtils.getSp(context, 15),
        ),
        middleText: '',
        radius: 5,
        backgroundColor: AppColors.lightGray,
        actions: actions);
  }
}
