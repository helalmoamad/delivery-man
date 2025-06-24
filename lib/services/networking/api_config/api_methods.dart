import 'dart:async';
import 'dart:convert';
import 'package:delivery_man_app/services/networking/api_config/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../controllers/Client/timer_service.dart';
import 'request_config.dart';

class ApiMethodsDelivery {
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
    final uri = Uri.parse(
        '${isChatUrl ? ApiConstantsDelivery.chatUrl : isMarketUrl ? ApiConstantsDelivery.marketUrl : ApiConstantsDelivery.deliveryUrl}/api/${ApiConstantsDelivery.version}/$urlPath');

    final Completer<Response> completer = Completer<Response>();

    try {
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
      debugPrint('/////1///////');
      /////////////////store request info//////////////////////////////////
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
    } finally {
      if (timerService.isTimerActive(isGlobalTimer: isGlobalTimer)) {
        timerService.stopTimer(isGlobalTimer: isGlobalTimer);
      }
      client.close();
    }
  }

  static Future<T> postRequest<T>({
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
      debugPrint('/////1///////');
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
    } finally {
      if (timerService.isTimerActive(isGlobalTimer: isGlobalTimer)) {
        timerService.stopTimer(isGlobalTimer: isGlobalTimer);
      }
      client.close();
    }
  }
}
