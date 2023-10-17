import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class TitleSectionWidget extends StatelessWidget {
  final String title;
  const TitleSectionWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      color: Get.isDarkMode ? AppColors.blackDark : AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: TextWidget(
            text: title,
            color: AppColors.blackDark,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
            maxline: 1),
      ),
    );
  }
}
