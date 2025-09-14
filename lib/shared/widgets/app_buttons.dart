import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class AppButton {
  static normalButton({
    required String title,
    VoidCallback? onPress,
    Color backgroundColor = AppColors.darkGrey,
    Color titleColor = Colors.white,
    double titleSize = 14,
    bool shadow = true,
    double height = 50,
    double width = double.infinity,
    Key? key1
  }) {
    return InkWell(
      onTap: onPress,
      key: key1,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: shadow
              ? const [
                  BoxShadow(color: AppColors.lightGray, blurRadius: 5),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: TextWidget(
              text: title,
              color: titleColor,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxline: 2),
        ),
      ),
    );
  }
}
