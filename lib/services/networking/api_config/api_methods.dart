import 'dart:async';
import 'dart:convert';
import 'package:delivery_man_app/main.dart';
import 'package:delivery_man_app/message_error_log/device_info_util.dart';
import 'package:delivery_man_app/message_error_log/errorLogModel.dart';
import 'package:delivery_man_app/services/networking/api_config/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/Client/timer_service.dart';
import '../../../message_error_log/PagesMonitor.dart';
import 'request_config.dart';

class ApiMethodsDelivery {
  static late Map<String, dynamic> deviceInfo;

  static void printLongText(String text) {
    final pattern = RegExp('.{1,800}', dotAll: true);
    for (final match in pattern.allMatches(text)) {
      debugPrint(match.group(0));
    }
  }

  static Future<T> getRequest<T>({
    required String urlPath,
    required String token,
    required Client client,
    required TimerService timerService,
    required bool isGlobalTimer,
    bool isMarketUrl = false,
    bool isChatUrl = false,
    bool isForOtp = false,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("lastApi", urlPath);
    final uri = Uri.parse(
        '${isChatUrl ? ApiConstantsDelivery.chatUrl : isMarketUrl ? ApiConstantsDelivery.marketUrl : ApiConstantsDelivery.deliveryUrl}/api/${ApiConstantsDelivery.version}/$urlPath');

    final Completer<Response> completer = Completer<Response>();

    try {
      debugPrint('\n\x1B[34m══════════════════════════════════════════════');
      debugPrint('🔵 [API URL]      : ${uri.toString()}');
      debugPrint(
          '\x1B[33m🟡 [HEADERS]      : {"Content-type": "application/json", "Accept": "application/json", "Authorization": "Bearer $token", "Connection": "keep-alive"}');
      // لا يوجد body في GET
      timerService.startTimer(
        isGlobalTimer: isGlobalTimer,
        duration: Duration(seconds: RequestConfigDelivery.timeoutSeconds),
        callback: () {
          if (!completer.isCompleted) {
            client.close();
            completer.completeError(TimeoutException(
                'The connection has timed out! after ${RequestConfigDelivery.timeoutSeconds} seconds'));
          }
        },
      );

      final responseFuture = client.get(
        uri,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Connection': 'keep-alive',
        },
      );

      // Complete the completer with the response
      responseFuture.then(
        (response) {
          if (!completer.isCompleted) {
            completer.complete(response);
          }
        },
      ).catchError(
        (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );

      final response = await completer.future;
      debugPrint('\x1B[32m🟢 [RESPONSE]     : ${response.statusCode}');
      debugPrint('\x1B[33m[RESPONSE HEADERS]: ${response.headers}');
      debugPrint('\x1B[32m[RESPONSE BODY]   :');
      ApiMethodsDelivery.printLongText(response.body);
      debugPrint(
          '\x1B[34m══════════════════════════════════════════════\x1B[0m\n');
      /////////////////store request info//////////////////////////////////
      ///
      if (response.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          "/insertNumberPage",
          (route) => false,
        );

        throw Exception("Unauthorized - Redirected to login");
      }

      if (response.statusCode != 200) {
        await errorSender.sendError(await DeviceInfoHelper.createErrorLog(
            errorType: response.toString(),
            lastFourPageVisited: lastFourPageVisited,
            errorPath: uri.toString(),
            lastApiRequest: uri.toString(),
            messageFromBackend: response.body));

        debugPrint(response.body);
      }
      await RequestConfigDelivery.storeRequestInfo(
        uri: uri,
        token: token,
        requestType: 'GET',
        body: '',
        response: response,
      );
      //////////////////////////////////////////////////////////////////
      return RequestConfigDelivery.processResponse<T>(
        response: response,
        fromJson: fromJson,
        timerService: timerService,
        isGlobalTimer: isGlobalTimer,
        urlPath: urlPath,
        isForOtp: isForOtp,
        isGet: true,
      );
    } catch (error, stack) {
      debugPrint('\x1B[31m🔴 [ERROR]        : ' + error.toString());
      debugPrint('Stack: ' + stack.toString());
      debugPrint(
          '\x1B[34m══════════════════════════════════════════════\x1B[0m\n');
      await errorSender.sendError(await DeviceInfoHelper.createErrorLog(
          errorType: error.toString(),
          lastFourPageVisited: lastFourPageVisited,
          errorPath: uri.toString(),
          lastApiRequest: uri.toString(),
          messageFromBackend: error.toString()));

      rethrow;
    } finally {
      if (timerService.isTimerActive(isGlobalTimer: isGlobalTimer)) {
        timerService.stopTimer(isGlobalTimer: isGlobalTimer);
      }
      client.close();
    }
  }

  static Future<T?> postRequest<T>({
    required String urlPath,
    required String? token,
    required Client client,
    required TimerService timerService,
    required bool isGlobalTimer,
    required Map<String, dynamic> body,
    T Function(Map<String, dynamic>)? fromJson,
    bool isMarketUrl = false,
    bool isChatUrl = false,
    bool isForOtp = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("lastApi", urlPath);

    final uri = Uri.parse(
        '${isChatUrl ? ApiConstantsDelivery.chatUrl : isMarketUrl ? ApiConstantsDelivery.marketUrl : ApiConstantsDelivery.deliveryUrl}/api/${ApiConstantsDelivery.version}/$urlPath');

    Map<String, String>? headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Connection': 'keep-alive',
    };

    if (token == null) {
      headers.remove('Authorization');
    }

    final Completer<Response> completer = Completer<Response>();

    try {
      debugPrint('\n\x1B[34m══════════════════════════════════════════════');
      debugPrint('🔵 [API URL]      : ${uri.toString()}');
      debugPrint('\x1B[33m🟡 [HEADERS]      : ' + headers.toString());
      debugPrint('\x1B[35m🟣 [BODY]         : ' + json.encode(body));
      timerService.startTimer(
        isGlobalTimer: isGlobalTimer,
        duration: Duration(seconds: RequestConfigDelivery.timeoutSeconds),
        callback: () {
          if (!completer.isCompleted) {
            client.close();
            completer.completeError(TimeoutException(
                'The connection has timed out! after ${RequestConfigDelivery.timeoutSeconds} seconds'));
          }
        },
      );

      final responseFuture = client.post(
        uri,
        body: json.encode(body),
        headers: headers,
      );
      // Complete the completer with the response
      responseFuture.then(
        (response) {
          if (!completer.isCompleted) {
            completer.complete(response);
          }
        },
      ).catchError(
        (error) {
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        },
      );

      final response = await completer.future;
      debugPrint('\x1B[32m🟢 [RESPONSE]     : ${response.statusCode}');
      debugPrint('\x1B[33m[RESPONSE HEADERS]: ${response.headers}');
      debugPrint('\x1B[32m[RESPONSE BODY]   :');
      ApiMethodsDelivery.printLongText(response.body);
      debugPrint(
          '\x1B[34m══════════════════════════════════════════════\x1B[0m\n');

      if (response.statusCode == 401) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        if (lastFourPageVisited.last == "OtpVerificationPage") {
          Get.snackbar("خطأ", "رمز التحقق غير صحيح",
              snackPosition: SnackPosition.BOTTOM);
          return null;
        }

        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          "/insertNumberPage",
          (route) => false,
        );

        throw Exception("Unauthorized - Redirected to login");
      }
      if (response.statusCode == 404 &&
          lastFourPageVisited.last == "OtpVerificationPage") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Future.delayed(const Duration(seconds: 2), () {
          
        });
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          "/insertNumberPage",
          (route) => false,
        );

        throw Exception("Unauthorized - Redirected to login");
      }
      if (response.statusCode != 200) {
        await errorSender.sendError(await DeviceInfoHelper.createErrorLog(
            errorType: response.toString(),
            lastFourPageVisited: lastFourPageVisited,
            errorPath: uri.toString(),
            lastApiRequest: uri.toString(),
            messageFromBackend: response.body));
        debugPrint(response.body);
      }

      /////////////////store request info//////////////////////////////////
      await RequestConfigDelivery.storeRequestInfo(
        uri: uri,
        token: token ?? '',
        requestType: 'POST',
        body: json.encode(body),
        response: response,
      );
      //////////////////////////////////////////////////////////////////
      return RequestConfigDelivery.processResponse<T>(
        response: response,
        fromJson: fromJson,
        timerService: timerService,
        isGlobalTimer: isGlobalTimer,
        urlPath: urlPath,
        isForOtp: isForOtp,
        isGet: false,
      );
    } catch (error, stack) {
      debugPrint('\x1B[31m🔴 [ERROR]        : ' + error.toString());
      debugPrint('Stack: ' + stack.toString());
      debugPrint(
          '\x1B[34m══════════════════════════════════════════════\x1B[0m\n');
      await errorSender.sendError(await DeviceInfoHelper.createErrorLog(
        errorType: error.toString(),
        lastFourPageVisited: lastFourPageVisited,
        errorPath: uri.toString(),
        lastApiRequest: uri.toString(),
      ));
      rethrow;
    } finally {
      if (timerService.isTimerActive(isGlobalTimer: isGlobalTimer)) {
        timerService.stopTimer(isGlobalTimer: isGlobalTimer);
      }
      client.close();
    }
  }
}
