import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../controllers/Client/timer_service.dart';
import '../../../models/RequestInfo/request_info_model.dart';
import '../../../shared/errors/exceptions.dart';
import '../../../shared/global_functions/global_functions.dart';
import 'package:http/http.dart';

class RequestConfig {
  static int timeoutSeconds = 60;

  static Future<void> storeRequestInfo({
    required Uri uri,
    required String token,
    required String requestType,
    required String body,
    required Response response,
  }) async {
    final data = RequestInfoModel(
      url: uri.toString(),
      requestType: requestType,
      token: token,
      header: response.headers.toString(),
      body: body,
      response: jsonDecode(response.body).toString(),
    );

    await GlobalFunctions.setLocalStorageData(
      infoData: data,
      fromJson: RequestInfoModel.fromJson,
      key: 'requestsInfo',
      maxNumberOfData: 100,
    );
  }

  static T processResponse<T>({
    required Response response,
    required T Function(Map<String, dynamic>)? fromJson,
    required TimerService timerService,
    required bool isGlobalTimer,
    required bool isGet,
    required String urlPath,
    bool isForOtp = false,
  }) {
    //////////////////////////////////////////////////////////////////
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      debugPrint('get $urlPath data success');
      if (isGet) {
        // Cancel the timer on successful response
        timerService.stopTimer(isGlobalTimer: isGlobalTimer);
        if (fromJson != null) {
          final resposeData = fromJson(data);
          return resposeData;
        } else {
          return data as T;
        }
      } else {
        if (data['isSuccessful'] == false && data['code'] == 400) {
          debugPrint('wrong entry data');
          throw WrongDataException();
        } else {
          // Cancel the timer on successful response
          timerService.stopTimer(isGlobalTimer: isGlobalTimer);
          if (fromJson != null) {
            final resposeData = fromJson(data);
            return resposeData;
          } else {
            return data as T;
          }
        }
      }
    } else if (response.statusCode == 422 && isForOtp) {
      throw OtpTryAgainException();
    } else {
      debugPrint('3');
      throw ServerException();
    }
  }
}
