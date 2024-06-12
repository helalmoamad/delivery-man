import 'package:delivery_man_app/controllers/Orders/orders_controller.dart';
import 'package:delivery_man_app/models/AssignToVehicle/assign_to_vehicle_model.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../providers/AssignToVehicle_providers/assign_to_vehicle_provider.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/snackbar_widgets.dart';

class QRController extends GetxController {
  final OrdersController ordersController = Get.find<OrdersController>();
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? barcode;

  bool isCircleShown = false;

  late AssignToVehicleProvider assignToVehicleProvider = Get.find();
  late AssignToVehicleModel assignToVehicleData;

  void showCircleIndicator() {
    isCircleShown = true;
    update();
  }

////////////////////////////
  void hideCircleIndicator() {
    isCircleShown = false;
    update();
  }

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

    qrViewController.scannedDataStream.listen((barcode) async {
      if (this.barcode == null) {
        this.barcode = barcode;
        debugPrint(barcode.code.toString());
        await assignToVehicle(
            token: GlobalFunctions.getToken(),
            vehicleId: int.parse(barcode.code!));
      }
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

  Future<void> assignToVehicle(
      {required String token, required int vehicleId}) async {
    showCircleIndicator();
    final failureOrAssignToVehicle =
        await assignToVehicleProvider.call(token: token, vehicleId: vehicleId);

    failureOrAssignToVehicle.fold((failure) {
      HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideCircleIndicator,
          showNoInternetPage: () {});
      Get.close(1);
    }, (getAssignToVehicleData) async {
      assignToVehicleData = getAssignToVehicleData;
      hideCircleIndicator();
      SnackBarWidgets.showSuccessSnackBar('Assign To Vehicle Succeeded'.tr, '');

      Future.wait([
        GlobalFunctions.setAssignVehicleToUserId(
            assignToUserId:
                assignToVehicleData.data!.assignedVehicle!.assignToUserId ??
                    -1),
        GlobalFunctions.setAssignedVehicleId(
            assignedVehicleId:
                assignToVehicleData.data!.assignedVehicle!.id ?? -1),
        GlobalFunctions.setAssignedVehicleName(
            assignedVehicleName:
                assignToVehicleData.data!.assignedVehicle!.name ?? ''),
      ]);
      Get.close(1);
      ordersController.update();
    });
  }
}
