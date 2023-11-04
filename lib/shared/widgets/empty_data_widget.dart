import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';
import '../helpers/screen_size_utils.dart';
import 'app_buttons.dart';

class EmptyDataWidget extends StatelessWidget {
  final Function() onTap;

  const EmptyDataWidget({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? AppColors.blackLight : AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/pictures/no orders.png',
              fit: BoxFit.cover,
              width: 200,
            ),
            //////////
            TextWidget(
                text: '${'No Orders'.tr}\n${'in this section'.tr}',
                color: AppColors.blackDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                maxline: 2),
            /////////
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: AppButton.normalButton(
                  height: 50,
                  width: double.infinity,
                  title: 'Try Again'.tr,
                  backgroundColor: AppColors.primaryDark,
                  shadow: false,
                  titleColor: AppColors.white,
                  onPress: onTap),
            ),
            //////////
            SizedBox(
              height: ScreenSizeUtils.getHeightInPercent(context, 8),
            ),
            ////////////
          ],
        ),
      ),
    );
  }
}
