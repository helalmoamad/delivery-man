// lib/core/error_reporting/dio_error_reporting_interceptor.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:delivery_man_app/message_error_log/errorLogModel.dart';
import 'package:dio/dio.dart';
import 'error_sender.dart';

typedef FutureStringGetter = Future<String?> Function();

class ErrorReportingInterceptor extends Interceptor {
  final ErrorSender sender;
  final FutureStringGetter? getUserId;
  final FutureStringGetter? getToken;
  final Map<String, String> deviceInfo;

  ErrorReportingInterceptor({
    required this.sender,
    this.getUserId,
    this.getToken,
    required this.deviceInfo,
  });

  String? _hashToken(String? token) {
    if (token == null) return null;
    final bytes = utf8.encode(token);
    return sha256.convert(bytes).toString();
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      final userId = getUserId == null ? null : await getUserId!();
      final token = getToken == null ? null : await getToken!();
      final tokenHash = _hashToken(token);

      final extra = <String, dynamic>{
        'statusCode': err.response?.statusCode,
        'responseData': _safeData(err.response?.data),
        'requestMethod': err.requestOptions.method,
        'requestUri': err.requestOptions.uri.toString(),
        'requestData': _safeData(err.requestOptions.data),
      };

      final log = ErrorLog(flutterVersion: '', deviceInfo: '', errorType: ''
      );

      await sender.sendError(log);
    } catch (e) {
      print('ErrorReportingInterceptor failed: $e');
    } finally {
      handler.next(err);
    }
  }

  dynamic _safeData(dynamic raw) {
    try {
      if (raw == null) return null;
      if (raw is Map) {
        final Map safe = {};
        raw.forEach((k, v) {
          final key = k.toString().toLowerCase();
          if (key.contains('password') || key.contains('token') || key.contains('authorization')) {
            safe[k] = '<<REDACTED>>';
          } else {
            safe[k] = v;
          }
        });
        return safe;
      }
      return raw;
    } catch (e) {
      return raw.toString();
    }
  }
}
