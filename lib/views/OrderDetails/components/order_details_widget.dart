import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class OrderDetailsWidget extends StatelessWidget {
  final String title;
  final String value;
  final Widget? widget;
  final double? height;

  const OrderDetailsWidget({
    Key? key,
    required this.title,
    required this.value,
    this.widget,
    this.height = 37,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(3),
            height: height,
            decoration: BoxDecoration(
                color: Get.isDarkMode ? AppColors.darkGrey : AppColors.white,
                border: Border.all(color: AppColors.grey, width: 0)),
            child: Center(
              child: TextWidget(
                  text: title,
                  color: AppColors.secondary,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.center,
                  maxline: 2),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(3),
            height: height,
            decoration: BoxDecoration(
                color: Get.isDarkMode ? AppColors.darkGrey : AppColors.white,
                border: Border.all(color: AppColors.grey, width: 0)),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: TextWidget(
                        text: value,
                        color: Get.isDarkMode
                            ? AppColors.grey
                            : AppColors.primaryLight,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.center,
                        maxline: 2),
                  ),
                ),
                ////////////////////////////
                widget == null ? Container() : Expanded(child: widget!),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
