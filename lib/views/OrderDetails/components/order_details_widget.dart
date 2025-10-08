import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class OrderDetailsWidget extends StatelessWidget {
  final String title;
  final String value;
  final Widget? widget;
  final double? height;
  final Color color;
  final bool isBold;

  const OrderDetailsWidget({
    Key? key,
    required this.title,
    required this.value,
    this.widget,
    this.height = 37,
    this.color = AppColors.white,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "OrderDetailsWidget");
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
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(3),
            height: height,
            decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: AppColors.grey,
                  width: 0,
                )),
            child: Center(
              child: TextWidget(
                  text: title,
                  color: AppColors.blackDark,
                  fontSize: 13,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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
                color: color,
                border: Border.all(color: AppColors.grey, width: 0)),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: TextWidget(
                        text: value,
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight:
                            isBold ? FontWeight.bold : FontWeight.normal,
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
