import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';
import '../helpers/screen_size_utils.dart';
import 'app_buttons.dart';

class AppDialogs {
  static void showAppDialogWidget({
    required BuildContext context,
    required String title,
    required List<Widget> actions,
    bool hideTitle = false,
  }) {
    Get.dialog(
      AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        title: hideTitle
            ? null
            : Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
        backgroundColor: AppColors.lightGray,
        content: Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: ScreenSizeUtils.getHeightInPercent(context, 80),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: hideTitle ? 0 : 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /////////////////////////////////
  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required Function() onConfirm,
    Function()? onBackActions,
  }) {
    Get.dialog(
      AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.lightGray,
        content: Container(
          width: MediaQuery.of(context).size.width,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: ScreenSizeUtils.getHeightInPercent(context, 80),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppButton.normalButton(
                          title: 'Confirm'.tr,
                          shadow: false,
                          height: 30,
                          titleColor: AppColors.white,
                          backgroundColor: AppColors.primaryDark,
                          onPress: onConfirm,
                        ),
                      ),
                      ////////////////
                      const SizedBox(
                        width: 10,
                      ),
                      ///////////////
                      Expanded(
                        child: AppButton.normalButton(
                          title: 'Back'.tr,
                          shadow: false,
                          backgroundColor: AppColors.white,
                          titleColor: AppColors.primaryDark,
                          height: 30,
                          onPress: () {
                            Get.back();
                            if (onBackActions != null) {
                              onBackActions();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// class AppDialogs {
//   static void showAppDialogWidget({
//     required BuildContext context,
//     required String title,
//     required List<Widget> actions,
//     // required Function() onConfirm
//   }) {
//     Get.defaultDialog(
//         title: title,
//         titleStyle: TextStyle(
//           color: AppColors.primaryDark,
//           fontSize: ScreenSizeUtils.getSp(context, 15),
//         ),
//         middleText: '',
//         radius: 5,
//         backgroundColor: AppColors.lightGray,
//         actions: actions);
//   }
// }
