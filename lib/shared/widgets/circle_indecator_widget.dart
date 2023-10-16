import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../constants/color_constants.dart';

class CircleIndicatorWidget extends StatelessWidget {
  final bool isBgWhite;
  const CircleIndicatorWidget({Key? key, this.isBgWhite = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitFadingFour(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: index.isEven ? AppColors.primaryDark : AppColors.secondary,
          ),
        );
      },
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: isBgWhite
              ? Get.isDarkMode
                  ? AppColors.blackLight
                  : AppColors.white
              : Colors.black.withOpacity(0.3),
        ),
        spinkit,
        // CircularProgressIndicator(
        //   color: Get.isDarkMode ? AppColors.lightGray : AppColors.primaryDark,
        // )
      ],
    );
  }
}
