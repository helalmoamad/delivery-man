import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRController extends GetxController {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? barcode;

  @override
  void onInit() {
    super.onInit();
    debugPrint('init QR');
  }

  @override
  void onClose() {
    super.onClose();
    qrViewController!.dispose();
    debugPrint('Close QR');
  }

  void onQRViewCreated(QRViewController qrViewController) {
    this.qrViewController = qrViewController;

    qrViewController.scannedDataStream.listen((barcode) {
      this.barcode = barcode;
      update();
    });
    update();
  }

  Future<void> toggleFlash() async {
    await qrViewController!.toggleFlash();
    update();
  }

  Future<void> flipCamira() async {
    await qrViewController!.flipCamera();
    update();
  }
}
