import 'package:delivery_man_app/shared/constants/lang_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/user_data_model.dart';
import '../../providers/Auth_providers/login_provider.dart';
import '../../providers/Auth_providers/logout_provider.dart';
import '../../providers/Auth_providers/set_fcm_token_provider.dart';
import '../../routes/routes.dart';
import '../../shared/global_functions/global_functions.dart';
import '../../shared/global_functions/push_notification_service.dart';
import '../../shared/handling_errors.dart/handling_errors.dart';
import '../../shared/widgets/snackbar_widgets.dart';

class AuthController extends GetxController {
  bool isCircleShown = false;
  bool isLogin = false;
  bool isObscure = true;

  SharedPreferences prefs = Get.find<SharedPreferences>();

  late LoginProvider loginProvider = Get.find<LoginProvider>();
  late SetFcmTokenProvider setFcmTokenProvider =
      Get.find<SetFcmTokenProvider>();
  late LogOutProvider logOutProvider = Get.find();

  late UserDataModel userData;

  ///////////////////
  void changeIsObscure() {
    isObscure = !isObscure;
    update();
  }

/////////////////////////
  void showCircleIndicator() {
    isCircleShown = true;
    update();
  }

////////////////////////////
  void hideCircleIndicator() {
    isCircleShown = false;
    update();
  }

/////////////////////////////

  Future<void> login({required LoginModel loginModel}) async {
    showCircleIndicator();
    final failureOrLogin = await loginProvider.call(loginModel);
    failureOrLogin.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: hideCircleIndicator,
            showNoInternetPage: () {});
      },
      (getUserData) async {
        userData = getUserData.data!;
        await PushNotificationService.getToken().then(
          (fcmToken) async {
            if (fcmToken != null) {
              ////////////////////////
              await sendFcmTokenApi(fcmToken: fcmToken);
            } else {
              hideCircleIndicator();
              SnackBarWidgets.showFailureSnackBar('Get fcm token faild', '');
            }
          },
        );
      },
    );
  }

  Future<void> sendFcmTokenApi({
    required String fcmToken,
  }) async {
    showCircleIndicator();
    final failureOrLogin = await setFcmTokenProvider.call(
      token: userData.accessToken ?? '',
      fcmToken: fcmToken,
    );
    failureOrLogin.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: hideCircleIndicator,
            showNoInternetPage: () {});
      },
      (data) async {
        isLogin = true;
        Future.wait([
          GlobalFunctions.setToken(token: userData.accessToken!),
          GlobalFunctions.setUserId(id: userData.id!),
          GlobalFunctions.setName(name: userData.name!),
          GlobalFunctions.setEmail(email: userData.email!),
          GlobalFunctions.setMobilePhone(mobilePhone: userData.mobilePhone!),
          GlobalFunctions.setAssignVehicleToUserId(
              assignToUserId: userData.assignedVehicle == null
                  ? -1
                  : userData.assignedVehicle!.assignToUserId ?? -1),
          GlobalFunctions.setAssignedVehicleId(
              assignedVehicleId: userData.assignedVehicle == null
                  ? -1
                  : userData.assignedVehicle!.id ?? -1),
          GlobalFunctions.setAssignedVehicleName(
              assignedVehicleName: userData.assignedVehicle == null
                  ? ''
                  : userData.assignedVehicle!.name ?? ''),
          GlobalFunctions.setIsLoggedIn(isLoggedIn: isLogin)
        ]);
        hideCircleIndicator();
        Get.offAllNamed(Routes.orderssPage);
        SnackBarWidgets.showSuccessSnackBar('Login Succeeded'.tr, '');
      },
    );
  }

  bool isLogoutCircleShown = false;
  /////////////////////////
  void showLogoutCircleIndicator() {
    if (isLogoutCircleShown == false) {
      isLogoutCircleShown = true;
      update(['logout']);
    }
  }

////////////////////////////
  void hideLogoutCircleIndicator() {
    if (isLogoutCircleShown == true) {
      isLogoutCircleShown = false;
      update(['logout']);
    }
  }

  //////////////////
  Future<void> logOut({
    required String token,
  }) async {
    showLogoutCircleIndicator();
    ///////////////////////////////////
    final failureOrLogout = await logOutProvider.call(token: token);
    failureOrLogout.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideLogoutCircleIndicator,
          showNoInternetPage: () {},
        );
      },
      (data) {
        isLogin = false;
        Future.wait([
          prefs.remove('token'),
          prefs.remove('userId'),
          prefs.remove('mobilePhone'),
          prefs.remove('name'),
          prefs.remove('email'),
          GlobalFunctions.setIsLoggedIn(isLoggedIn: isLogin)
        ]);
        Get.offAllNamed(Routes.loginPage);
      },
    );
  }

  //for setting language

  Future<void> changeLanguage(String lang) async {
    if (GlobalFunctions.getLanLocal() == lang) {
      return;
    }
    if (lang == LangConstants.ara) {
      await saveLanguage(LangConstants.ara);
    } else {
      await saveLanguage(LangConstants.ene);
    }
    await Get.updateLocale(Locale(lang));
    update();
  }

  Future<void> saveLanguage(String lang) async {
    await GlobalFunctions.setLanLocal(lanLocal: lang);
  }

  int moreDeveloperInfoIndex = 0;

  Future<void> removeRequestFromDeveloperInfo(int index) async {
    await GlobalFunctions.deleteRequestInfo(index: index);
    update();
  }

  Future<void> removeAllRequestsInfo() async {
    await GlobalFunctions.deleteAllRequestsInfo();
    update();
  }
}
