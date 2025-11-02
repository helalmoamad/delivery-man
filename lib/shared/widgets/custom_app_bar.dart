import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

AppBar customAppBar({
  required String title,
  required Widget button,
}) {
  return AppBar(
    elevation: 5,
    shadowColor: AppColors.lightGray,
    centerTitle: false,
    backgroundColor: const Color.fromARGB(255, 238, 243, 226),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: TextWidget(
              text: title,
              color: AppColors.primaryDark,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
              maxline: 1),
        ),
        ////////////////////////////////
        Expanded(flex: 3, child: button)
      ],
    ),
    // actions: actions,
  );
}
