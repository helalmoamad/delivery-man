import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../constants/failure_messages.dart';
import '../errors/failures.dart';
import '../widgets/circle_indecator_widget.dart';
import '../widgets/no_connection_widget.dart';
import '../widgets/snackbar_widgets.dart';

class HandlingFailures {
  static void networkErrorrHandling(
      {required Failure failure,
      required Function() hideCircleIndicator,
      required Function() showNoInternetPage,
      int seconds = 2}) {
    switch (failure.runtimeType) {
      case ServerFailure:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar(
            'Server Error'.tr, AppFailureMessages.serverFailureMessage);
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
        SnackBarWidgets.showFailureSnackBar(
            'Wrong Data'.tr, AppFailureMessages.wrongDataFailureMessage);
        break;
      case CantAssignToVehicleFailure:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar(
            AppFailureMessages.cantAssignToVehicleMessage, '');
        break;
      case ClientCloseFailure:
        break;
      default:
        hideCircleIndicator();
        showNoInternetPage();
        SnackBarWidgets.showFailureSnackBar(
            'Unexpected error'.tr, AppFailureMessages.unExpectedFailureMessage);
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
