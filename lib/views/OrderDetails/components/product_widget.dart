import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/PagesMonitor.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../shared/constants/color_constants.dart';
import '../../../shared/widgets/text_widget.dart';

class ProductsWidget extends StatelessWidget {
  final String img, title, price, quantity;
  const ProductsWidget({
    Key? key,
    required this.title,
    required this.price,
    required this.img,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PagesMonitor.addPageToList(page: "ProductsWidget");
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
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
        height: 130,
        child: Card(
          elevation: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress, strokeWidth: 3),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: img,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              //////////////
              Expanded(
                flex: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextWidget(
                          text: title,
                          color: AppColors.primaryDark,
                          fontSize: 13,
                          minFontSize: 10,
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxline: 3),
                      ////////////////////
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextWidget(
                            text: '$price *$quantity',
                            color: AppColors.blackDark,
                            fontSize: 14,
                            minFontSize: 14,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxline: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
