import 'package:delivery_man_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

AppBar customAppBar({required String title, required List<Widget>? actions}) {
  return AppBar(
    elevation: 5,
    shadowColor: AppColors.lightGray,
    centerTitle: false,
    backgroundColor: AppColors.white,
    title: TextWidget(
        text: title,
        color: AppColors.primaryDark,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        textAlign: TextAlign.start,
        maxline: 1),
    actions: actions,
  );
}
