import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:delivery_man_app/TrydosChat/api/status_code_type.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/prefs_repository.dart';
import 'package:delivery_man_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

enum _StatusType {
  succeed,
  failed,
}

class LoggerInterceptor extends Interceptor with HandlingExceptionRequest {
  final PrefsRepository _prefsRepository = GetIt.I<PrefsRepository>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      log(_prefsRepository.chatToken.toString());
      log('story ${_prefsRepository.storiesToken.toString()}');
      prettyPrinterI(
        "***|| INFO Request ${options.path} ||***"
        "\n HTTP Method: ${options.method}"
        "\n token : ${options.headers[HttpHeaders.authorizationHeader]}"
        "\n param : ${options.data}"
        "\n url: ${options.path}"
        "\n Header: ${options.headers}"
        "\n timeout: ${options.connectTimeout! ~/ 1000}s",
      );
    }
    _prefsRepository.saveRequestsData(
        'This From Request   ${options.path}',
        options.data is! FormData ? options.data : {'data': 'formData'},
        options.headers,
        null,
        options.method,
        options.queryParameters,
        options.data is! FormData ? options.data : {'data': 'formData'});

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _StatusType statusType;
      if (response.statusCode == StatusCode.operationSucceeded.code || response.statusCode == 201) {
        statusType = _StatusType.succeed;
      } else {
        statusType = _StatusType.failed;
      }
      final requestRoute = response.requestOptions.path;

      if (statusType == _StatusType.failed) {
        prettyPrinterError(
            '***|| ${statusType.name.toUpperCase()} Response into -> $requestRoute ||***');
      } else {
        prettyPrinterV(
            '***|| ${statusType.name.toUpperCase()} Response into -> $requestRoute ||***');
      }
      prettyPrinterWtf(
        "***|| INFO Response Request $requestRoute ${statusType == _StatusType.succeed ? '✊' : ''} ||***"
        "\n Status code: ${response.statusCode}"
        "\n Status message: ${response.statusMessage}"
        "\n Data: ${response.data}",
      );
    }

    /////////////////////////////////////////////////////
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if ((jsonDecode(err.response.toString())["message"]
                  .toString()
                  .contains("Unauth") ||
              jsonDecode(err.response.toString())["code"].toString() ==
                  "401")) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        _prefsRepository.setChatToken("");
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          "/insertNumberPage",
          (route) => false,
        );
      }
    } catch (e) {
      log(e.toString());
    }

    if (kDebugMode) {
      prettyPrinterError(
        "***|| SOMETHING ERROR 💔 ||***"
        "\n url: ${err.requestOptions.path}"
        "\n error: ${err.error}"
        "\n response: ${err.response}"
        "\n message: ${err.message}"
        "\n type: ${err.type}"
        "\n stackTrace: ${err.stackTrace}",
      );
      _prefsRepository.saveRequestsData(
          err.requestOptions.path,
          {'error': err.error.toString()},
          err.response?.headers.map ?? {},
          err.response?.statusCode,
          err.requestOptions.method,
          err.requestOptions.queryParameters,
          err.requestOptions.data);
    }

    handler.next(err);
  }
}
