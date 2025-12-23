import 'dart:async';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_event.dart';
import 'package:delivery_man_app/models/Auth/chat_login_model.dart';
import 'package:delivery_man_app/models/Auth/send_otp_model.dart'
    show OtpResponse;
import 'package:delivery_man_app/models/Auth/verify_otp_model.dart';
import 'package:delivery_man_app/providers/Auth_providers/chat_login_provider.dart'
    show ChatLoginProvider;
import 'package:delivery_man_app/providers/Auth_providers/send_otp_provider.dart'
    show SendOtpProvider;
import 'package:delivery_man_app/providers/Auth_providers/verify_otp_provider.dart'
    show VerifyOtpProvider;
import 'package:delivery_man_app/shared/constants/lang_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Auth/login_model.dart';
import '../../models/Auth/user_data_model.dart';
import '../../models/RequestInfo/request_info_model.dart';
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

  String countryCode = '+963';

  String currentPhoneNumber = '';
  String otpMethod = 'whatsapp';

  SharedPreferences prefs = Get.find<SharedPreferences>();

  late LoginProvider loginProvider = Get.find<LoginProvider>();
  late SetFcmTokenProvider setFcmTokenProvider =
      Get.find<SetFcmTokenProvider>();
  final PrefsRepository _prefsRepository = GetIt.I<PrefsRepository>();
  late LogOutProvider logOutProvider = Get.find();

  late SendOtpProvider sendOtpProvider = Get.find<SendOtpProvider>();

  late VerifyOtpProvider verifyOtpProvider = Get.find<VerifyOtpProvider>();

  late ChatLoginProvider chatLoginProvider = Get.find<ChatLoginProvider>();

  late UserDataModel userData;

  void chooseOtpMethod({required String method}) {
    otpMethod = method;
    update();
  }

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

  Future<void> login({
    required LoginModel loginModel,
  }) async {
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
            GetIt.I<PrefsRepository>().setFcmToken(fcmToken ?? "");

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
      token: verifyOtpData?.data?.authToken ?? '',
      fcmToken: fcmToken,
    );
    failureOrLogin.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: hideVerifyOtpCircleIndicator,
            showNoInternetPage: () {});
      },
      (data) async {
        isLogin = true;
        Future.wait([
          GlobalFunctions.setToken(token: verifyOtpData?.data?.authToken ?? ''),
          GlobalFunctions.setUserId(id: verifyOtpData!.data!.id!),
          GlobalFunctions.setName(name: verifyOtpData!.data!.name!),
          GlobalFunctions.setEmail(email: verifyOtpData!.data!.email!),
          GlobalFunctions.setMobilePhone(
              mobilePhone: verifyOtpData!.data!.mobilePhone!),
          GlobalFunctions.setAssignVehicleToUserId(
              assignToUserId: verifyOtpData!.data!.assignedVehicle == null
                  ? -1
                  : verifyOtpData!.data!.assignedVehicle!.assignToUserId ?? -1),
          GlobalFunctions.setAssignedVehicleId(
              assignedVehicleId: verifyOtpData!.data!.assignedVehicle == null
                  ? -1
                  : verifyOtpData!.data!.assignedVehicle!.id ?? -1),
          GlobalFunctions.setAssignedVehicleName(
              assignedVehicleName: verifyOtpData!.data!.assignedVehicle == null
                  ? ''
                  : verifyOtpData!.data!.assignedVehicle!.name ?? ''),
          GlobalFunctions.setIsLoggedIn(isLoggedIn: isLogin)
        ]);
        hideVerifyOtpCircleIndicator();
        ///////////////////////////////////////////
        await chatLogin(
          mobilePhone: GlobalFunctions.getMobilePhone(),
          otpIdToken: verifyOtpData!.idToken ?? '',
          name: GlobalFunctions.getName(),
          originalUserId: GlobalFunctions.getUserId(),
        );
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
        Get.offAllNamed(Routes.insertNumberPage);
        hideLogoutCircleIndicator();
      },
    );
  }

  bool isSendOtpCircleShown = false;

/////////////////////////
  void showSendOtpCircleIndicator() {
    isSendOtpCircleShown = true;
    update();
  }

////////////////////////////
  void hideSendOtpCircleIndicator() {
    isSendOtpCircleShown = false;
    update();
  }

  OtpResponse? sendOtpData;

  Future<void> sendOtp({
    required String phone,
    required int isViaWhatsapp,
  }) async {
    showSendOtpCircleIndicator();
    await GlobalFunctions.removeVerificationId();

    final failureOrData =
        await sendOtpProvider.call(phone: phone, isViaWhatsapp: isViaWhatsapp);
    failureOrData.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
            failure: failure,
            hideCircleIndicator: hideSendOtpCircleIndicator,
            showNoInternetPage: () {});
      },
      (data) async {
        sendOtpData = data;
        GlobalFunctions.setVerificationId(
          verificationId: sendOtpData!.sessionInfo,
        );
        hideSendOtpCircleIndicator();
      },
    );
  }

  ///////////////////////////
  bool isVerifyOtpCircleShown = false;

/////////////////////////
  void showVerifyOtpCircleIndicator() {
    isVerifyOtpCircleShown = true;
    update();
  }

////////////////////////////
  void hideVerifyOtpCircleIndicator() {
    isVerifyOtpCircleShown = false;
    update();
  }

  OtpVerificationResponse? verifyOtpData;

  Future<void> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    showVerifyOtpCircleIndicator();
    final failureOrData =
        await verifyOtpProvider.call(verificationId: verificationId, otp: otp);
    failureOrData.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideVerifyOtpCircleIndicator,
          showNoInternetPage: () {},
        );
      },
      (data) async {
        verifyOtpData = data;
        await PushNotificationService.getToken().then(
          (fcmToken) async {
            GetIt.I<PrefsRepository>().setFcmToken(fcmToken ?? "");

            if (fcmToken != null) {
              ////////////////////////
              await sendFcmTokenApi(fcmToken: fcmToken);
            } else {
              hideVerifyOtpCircleIndicator();
              SnackBarWidgets.showFailureSnackBar('Get fcm token failed', '');
            }
          },
        );
        // hideVerifyOtpCircleIndicator();
        ////////////////////
        // await chatLogin(
        //   mobilePhone: GlobalFunctions.getMobilePhone(),
        //   otpIdToken: verifyOtpData!.idToken ?? '',
        //   name: GlobalFunctions.getName(),
        //   originalUserId: GlobalFunctions.getUserId(),
        // );
      },
    );
  }

  ///////////////////////////
  bool isChatLoginCircleShown = false;

/////////////////////////
  void showChatLoginCircleIndicator() {
    isChatLoginCircleShown = true;
    update();
  }

////////////////////////////
  void hideChatLoginCircleIndicator() {
    isChatLoginCircleShown = false;
    update();
  }

  ChatLoginModel? chatLoginData;

  Future<void> chatLogin({
    required String mobilePhone,
    required String otpIdToken,
    required String name,
    required int originalUserId,
  }) async {
    showChatLoginCircleIndicator();
    final failureOrData = await chatLoginProvider.call(
      mobilePhone: mobilePhone,
      otpIdToken: otpIdToken,
      name: name,
      originalUserId: originalUserId,
    );
    failureOrData.fold(
      (failure) {
        HandlingFailures.networkErrorrHandling(
          failure: failure,
          hideCircleIndicator: hideChatLoginCircleIndicator,
          showNoInternetPage: () {},
        );
      },
      (data) async {
        chatLoginData = data;
        GetIt.I<ChatBloc>().add(StoreFcmTokenEvent(
          
            userId: chatLoginData!.data!.id!,
            fcmToken: GetIt.I<PrefsRepository>().getFcmToken ?? ""));
        
        await _prefsRepository
            .setChatToken(chatLoginData!.data!.accessToken ?? '');

        await _prefsRepository.setMyChatId(chatLoginData!.data!.id ?? 0);
        await _prefsRepository
            .setMyChatName(chatLoginData!.data!.name ?? 'No Name');
        await _prefsRepository
            .setMyChatPhoto(chatLoginData!.data!.photoPath ?? '');
        await GlobalFunctions.setChatToken(
            chatToken: chatLoginData!.data!.accessToken ?? '');
        

        hideChatLoginCircleIndicator();
        SnackBarWidgets.showSuccessSnackBar('Login Succeeded'.tr, '');
        Get.offAllNamed(Routes.orderssPage);
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
    await GlobalFunctions.deleteLocalStorageData(
      index: index,
      fromJson: RequestInfoModel.fromJson,
      key: 'requestsInfo',
    );
    update();
  }

  Future<void> removeAllRequestsInfo() async {
    await GlobalFunctions.deleteAllLocalStorageData(key: 'requestsInfo');
    update();
  }
}
