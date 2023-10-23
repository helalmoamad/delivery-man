import 'package:delivery_man_app/controllers/QR/qr_controller.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/helpers/screen_size_utils.dart';
import 'package:delivery_man_app/shared/widgets/circle_indecator_widget.dart';
import 'package:delivery_man_app/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRPage extends StatelessWidget {
  final QRController qrController = Get.find<QRController>();
  ScanQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: customAppBar(
                title: 'Assign To Vehicle'.tr, button: Container()),
            body: GetBuilder<QRController>(builder: (_) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  buildQRView(context),
                  /////////////////////////////////
                  qrController.qrViewController == null
                      ? Container()
                      : buildControlButtons(),
                  /////////////////////////////////
                  qrController.isCircleShown
                      ? const CircleIndicatorWidget()
                      : Container(),
                ],
              );
            })));
  }

  Widget buildQRView(BuildContext context) {
    return QRView(
      key: qrController.qrKey,
      overlay: QrScannerOverlayShape(
          borderColor: AppColors.primaryDark,
          borderWidth: 10,
          borderLength: 30,
          borderRadius: 10,
          cutOutSize: ScreenSizeUtils.getWidthInPercent(context, 80)),
      onQRViewCreated: qrController.onQRViewCreated,
    );
  }

  Widget buildControlButtons() {
    return Positioned(
      top: 0,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8))),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                icon: FutureBuilder<bool?>(
                  future: qrController.qrViewController!.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off,
                        color: AppColors.white,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                onPressed: () async {
                  await qrController.toggleFlash();
                }),
            ////////////////////
            IconButton(
                icon: FutureBuilder(
                  future: qrController.qrViewController!.getCameraInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return const Icon(
                        Icons.switch_camera,
                        color: AppColors.white,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                onPressed: () async {
                  await qrController.flipCamira();
                }),
          ],
        ),
      ),
    );
  }
}
