import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Orders/upload_voice_model.dart';
import '../shared/constants/failure_messages.dart';
import '../shared/errors/failures.dart';
import '../shared/global_functions/global_functions.dart';
import 'network/order_network.dart';
import 'providers/upload_order_file.dart';
import 'repositories/order_background_repository.dart';

class BackGroundServiceUtils {
  static final service = FlutterBackgroundService();
  static late InternetConnectionChecker internetConnectionChecker;

  ////
  static late OrderNetworkApi orderNetworkApi;
  static late OrderBackGroundRepository orderBackGroundRepository;
  static late UploadFileProvider uploadFileProvider;

  static Future<void> initializeService() async {
    await service.configure(
        iosConfiguration: IosConfiguration(
          autoStart: false,
          onForeground: onStart,
          onBackground: onIosBackground,
        ),
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          isForegroundMode: true,
          autoStart: false,
        ));
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

    internetConnectionChecker = InternetConnectionChecker();
    orderNetworkApi = OrderNetworkApi();
    orderBackGroundRepository = OrderBackGroundRepository(
        orderNetworkApi: orderNetworkApi,
        internetConnectionChecker: internetConnectionChecker);
    uploadFileProvider = UploadFileProvider(orderBackGroundRepository);

    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    debugPrint('Background Service is Running');

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: 'File Upload Service', content: "Your file is uploading");
      }
    }

    bool test = Get.isRegistered<SharedPreferences>();
    if (!test) {
      final sharedPreferences = await SharedPreferences.getInstance();
      Get.put<SharedPreferences>(sharedPreferences);
    }

    String? token = GlobalFunctions.getToken();
    debugPrint(token);

    int index = 0;

    while (true) {
      await GlobalFunctions.reloadPrefs();
      ///////////////////////////////////////////
      List<UploadVoiceModel> data = GlobalFunctions.getLocalStorageData(
        fromJson: UploadVoiceModel.fromJson,
        key: 'upload_voice',
      );
      if (data.isNotEmpty) {
        debugPrint(
            'Order Id : ${data[index].orderId} , file path : ${data[index].filePath}');

        final failureOrData = await uploadFileProvider.call(
          token: token,
          orderId: data[index].orderId,
          file: data[index].filePath,
        );

        bool isFailure = false;

        failureOrData.fold(
          (failure) {
            debugPrint(_mapFailureToMessage(failure));
            isFailure = true;
          },
          (res) async {
            isFailure = false;
            debugPrint(
                '///////////////////////////// File Uploaded ////////////////////////////////');
          },
        );
        if (isFailure) {
          break;
        } else {
          final file = File(data[index].filePath);
          if (await file.exists()) {
            await file.delete();
            debugPrint('File deleted: ${data[index].filePath}');
          }
          await GlobalFunctions.deleteLocalStorageData(
            index: index,
            fromJson: UploadVoiceModel.fromJson,
            key: 'upload_voice',
          );
        }
      } else {
        debugPrint('Background Service Stop Running');
        break;
      }
    }

    service.stopSelf();
  }

  static String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppFailureMessages.serverFailureMessage;
      case OfflineFailure:
        return AppFailureMessages.offlineFailureMessage;
      default:
        return " Unexpected error,Please try again later.";
    }
  }
}
