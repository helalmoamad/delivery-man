import 'dart:io';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:delivery_man_app/Connectivity_Plus/checkInterNetByConnectivity.dart';
import 'package:delivery_man_app/TrydosChat/di/di_container.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_bloc.dart';
import 'package:delivery_man_app/TrydosChat/presentation/manager/chat_event.dart';
import 'package:delivery_man_app/controllers/Auth/auth_controller.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/message_error_log/dio_error_reporting_interceptor.dart';
import 'package:delivery_man_app/message_error_log/errorLogModel.dart';
import 'package:delivery_man_app/message_error_log/error_sender.dart';
import 'package:delivery_man_app/providers/Auth_providers/set_fcm_token_provider.dart';
import 'package:delivery_man_app/routes/routes.dart';
import 'package:delivery_man_app/services/networking/api_config/api_methods.dart';
import 'package:delivery_man_app/services/service_provider.dart';
import 'package:delivery_man_app/shared/constants/color_constants.dart';
import 'package:delivery_man_app/shared/constants/lang_constants.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:delivery_man_app/themes/themes.dart';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:smartlook/smartlook.dart';
//import 'package:smartlook/smartlook.dart';
import 'app_bindings.dart';
import 'background_service/background_service.dart';
import 'language/localization.dart';
import 'shared/global_functions/push_notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
showCallKitIncoming(Map<String, dynamic> data, String currentUuid,
    {required bool isVideo}) async {
  print("${data["message"]})");
  print("))))))))))))))${data["message"]['channel']}");
  CallKitParams callKitParams = CallKitParams(
    id: currentUuid,
    nameCaller: data["message"]['channel']["channel_name"] ?? 'Un Known',
    appName: 'Trydos',
    avatar: data["message"]['channel']["photo_path"] ??
        'https://trydos.s3.ap-south-1.amazonaws.com/images/5TPxSXKGAv3kLkbKIz5noTTmaZBwXNtSpJMoh7lE.jpg',
    handle: data['payload']['mobilePhone'],
    type: isVideo ? 1 : 0,
    textAccept: isVideo ? 'Accept Video' : 'Accept Call',
    textDecline: 'Decline',
    missedCallNotification: const NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: 'Missed call',
      callbackText: 'Call back',
    ),
    duration: 60000,
    extra: <String, dynamic>{
      'channel_id': data["message"]["channel_id"].toString(),
      'message_id': data["message"]["id"].toString(),
      'type': isVideo ? 'video' : 'voice'
    },
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: AndroidParams(
        isCustomNotification: true,
        isImportant: true,
        isShowFullLockedScreen: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: isVideo ? '#2D1B4B' : '#0955fa',
        backgroundUrl:
            'https://trydos.s3.ap-south-1.amazonaws.com/images/5TPxSXKGAv3kLkbKIz5noTTmaZBwXNtSpJMoh7lE.jpg',
        actionColor: isVideo ? '#FF1744' : '#4CAF50',
        incomingCallNotificationChannelName: "Incoming Call",
        missedCallNotificationChannelName: "Missed Call"),
    ios: const IOSParams(
      iconName: 'CallKitLogo',
      handleType: 'generic',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
}

late ItemScrollController myOrderStatusScrollController;
bool isDependencyInitialized = false;
bool isAssignToMeForReturnOrder = false;
late Dio appDio;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
AuthController auth = AuthController();
SetFcmTokenProvider setFcmTokenProvider = Get.find<SetFcmTokenProvider>();
List<String> lastFourPageVisited = [];
late ErrorSender errorSender;
int appVersion = 1;

Future<void> main() async {
  myOrderStatusScrollController = ItemScrollController();
  WidgetsFlutterBinding.ensureInitialized();
  // send errors to backend

  ApiMethodsDelivery.deviceInfo =
      await DeviceInfoHelper.collectDeviceAndAppInfo();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);

  await PushNotificationService.initializeNotification();
  await Permission.notification.isDenied.then((value) async {
    if (value) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  });

  await configureDependencies();
  isDependencyInitialized = true;
  await BackGroundServiceUtils.initializeService();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.statusBarColor,
  ));

  HttpOverrides.global = MyHttpOverrides();

  /////////////////////////////////////////
  ///
  ///
  errorSender = ErrorSender(
    endpoint: dotenv.env['ErrorURLSENDER']!,
  );
  await errorSender.flushPendingLogs();

  ///////////////send fcm to backend//////////////////////////
  var myFcmToken = await FirebaseMessaging.instance.getToken();
  if (myFcmToken != null) {
    var userIdd = GetIt.I<PrefsRepository>().myChatId;
    if (userIdd != null && userIdd != -1) {
      GetIt.I<ChatBloc>()
          .add(StoreFcmTokenEvent(userId: userIdd, fcmToken: myFcmToken));
    } else {}
  }

  // Sentry + Smartlook
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.tracesSampleRate = 0.1;
    },
    appRunner: () async {
      // var smartlookKey = dotenv.env['SMARTLOOK_KEY'];
      // if (smartlookKey!.isNotEmpty) {
      //   final setupOptions = (SetupOptionsBuilder(smartlookKey)
      //         ..StartNewSession = true
      //         ..Fps = 2)
      //       .build();

      //   await Smartlook.setupAndStartRecording(setupOptions);
      // }
      // تعريف أخطاء Flutter
      FlutterError.onError = (details) async {
        FlutterError.presentError(details);
        final log = await DeviceInfoHelper.createErrorLog(
            errorType:
                "Type:${details.exception.runtimeType.toString()} ${details.exceptionAsString().toString()}",
            lastFourPageVisited: lastFourPageVisited,
            errorPath: details.stack.toString(),
            lastApiRequest: '');
        await errorSender.sendError(log);
        await Sentry.captureException(details.exception,
            stackTrace: details.stack);
      };
      ConnectivityService.startListening();

      runApp(const MyApp());
    },
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);

//     return ServiceProvider(
//       child: GetMaterialApp(
//         navigatorKey: navigatorKey,

//         title: 'Delivery Man',
//         debugShowCheckedModeBanner: false,
//         theme: Themes.lightTheme,
//         //for language
//         locale: Locale(GlobalFunctions.getLanLocal()),
//         fallbackLocale: const Locale(LangConstants.ene),
//         translations: LocalizationApp(),
//         ////
//         getPages: AppRoutes.routes,
//         initialRoute: Routes.splashPage,
//         initialBinding: AppBinding(),
//       ),
//     );
//   }
// }
bool declineCallBecauseOfNotificationButton = false;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("FFFFFFFFFFFFFFFFFFddddddddddddddddddddddddd");
      if (GetIt.I<PrefsRepository>().chatToken != null && Get.context != null) {
        PushNotificationService.checkAndNavigationCallingPage(Get.context!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ConnectivityWrapper(
      child: ServiceProvider(
        child: GetMaterialApp(
          navigatorKey: navigatorKey,
          title: 'Delivery Man',
          debugShowCheckedModeBanner: false,
          theme: Themes.lightTheme,

          // اللغة
          locale: Locale(GlobalFunctions.getLanLocal()),
          fallbackLocale: const Locale(LangConstants.ene),
          translations: LocalizationApp(),

          // التوجيه
          getPages: AppRoutes.routes,
          initialRoute: Routes.splashPage,
          initialBinding: AppBinding(),
        ),
      ),
    );
  }
}
