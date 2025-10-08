import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class TitleSectionWidget extends StatelessWidget {
  final String title;
  final String index;
  final Widget? widget;
  const TitleSectionWidget({
    super.key,
    required this.title,
    required this.index,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "TitleSectionWidget");
    FlutterError.onError = (details) async {
      FlutterError.presentError(details);
      final log = await DeviceInfoHelper.createErrorLog(
          errorType: "Flutter Error",
          lastFourPageVisited: lastFourPageVisited,
          errorPath: lastFourPageVisited.last ?? "",
          lastApiRequest: '');
      await errorSender.sendError(log);
      await Sentry.captureException(details.exception,
          stackTrace: details.stack);
    };
    return Container(
      width: double.infinity,
      height: 48,
      color: Get.isDarkMode ? AppColors.blackDark : AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Row(
          children: [
            TextWidget(
                text: index,
                color: AppColors.blackDark,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                maxline: 1),
            ////////////
            TextWidget(
                text: title,
                color: AppColors.blackDark,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
                maxline: 1),
            // ///////////
            widget == null ? Container() : const Spacer(),
            // //////////
            widget ?? Container(),
          ],
        ),
      ),
    );
  }
}
