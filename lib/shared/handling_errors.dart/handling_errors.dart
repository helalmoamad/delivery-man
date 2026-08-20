import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../constants/failure_messages.dart';
import '../errors/failures.dart';
import '../widgets/circle_indecator_widget.dart';
import '../widgets/no_connection_widget.dart';
import '../widgets/snackbar_widgets.dart';

class HandlingFailures {
  static void networkErrorrHandling(
      {required FailureDelivery failure,
      required Function() hideCircleIndicator,
      required Function() showNoInternetPage,
      int seconds = 2}) {
    switch (failure.runtimeType) {
      case ServerFailure:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar('Server Error'.tr,
            failure.message ?? AppFailureMessages.serverFailureMessage);
        break;
      case OfflineFailure:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar(
            'No Connection'.tr, AppFailureMessages.offlineFailureMessage);
        break;
      case WrongDataFailure:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar('Wrong Data'.tr,
            failure.message ?? AppFailureMessages.wrongDataFailureMessage);
        break;
      case CantAssignToVehicleFailure:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar(
          failure.message ?? AppFailureMessages.cantAssignToVehicleMessage,
          '',
        );
        break;
      case ClientCloseFailure:
        break;
      case OtpTryAgainFailure:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar(
          failure.message ?? AppFailureMessages.unExpectedFailureMessage,
          seconds: 4,
          '',
        );
        break;
      default:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar('Unexpected error'.tr,
            failure.message ?? AppFailureMessages.unExpectedFailureMessage);
        break;
    }
  }

  ////////////////////////
  static Widget pageErrorHandling({
    required bool isCircleShown,
    required bool isNoInternetConnection,
    required Widget page,
    required dynamic Function() onTapTry,
  }) {
    return isCircleShown
        ? const CircleIndicatorWidget(
            isBgWhite: true,
          )
        : isNoInternetConnection
            ? NoConnectionWidget(onTap: onTapTry)
            : page;
  }
}