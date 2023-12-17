import 'dart:convert';
import 'package:delivery_man_app/models/RequestInfo/request_info_model.dart';
import 'package:delivery_man_app/services/networking/api_constants.dart';
import 'package:delivery_man_app/shared/errors/exceptions.dart';
import 'package:delivery_man_app/shared/global_functions/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ApiRequests {
  static Future<T> getRequest<T>({
    required String urlPath,
    required String token,
    required Client client,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/$urlPath');
    final response = await client.get(
      uri,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive',
      },
    ).timeout(const Duration(seconds: 30));
    debugPrint('/////1///////');

    /////////////////store request info//////////////////////////////////
    final data = RequestInfoModel(
        url: uri.toString(),
        requestType: 'GET',
        token: token,
        header: response.headers.toString(),
        body: '',
        response: jsonDecode(response.body).toString());

    await GlobalFunctions.setRequestInfo(requestInfo: data);
    //////////////////////////////////////////////////////////////////
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      debugPrint('get $urlPath data success');

      if (fromJson != null) {
        final resposeData = fromJson(data);
        return resposeData;
      } else {
        return data as T;
      }
    } else {
      debugPrint('3');
      throw ServerException();
    }
  }

  static Future<T> postRequest<T>({
    required String urlPath,
    required String token,
    required Client client,
    required Map<String, dynamic> body,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}/api/${ApiConstants.version}/$urlPath');
    final response = await client.post(
      uri,
      body: json.encode(body),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Connection': 'keep-alive',
      },
    ).timeout(const Duration(seconds: 30));
    debugPrint('/////1///////');
    /////////////////store request info//////////////////////////////////
    final data = RequestInfoModel(
        url: uri.toString(),
        requestType: 'POST',
        token: token,
        header: response.headers.toString(),
        body: body.toString(),
        response: jsonDecode(response.body).toString());

    await GlobalFunctions.setRequestInfo(requestInfo: data);
    //////////////////////////////////////////////////////////////////
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      final data = jsonDecode(response.body);
      debugPrint('get $urlPath data success');
      if (data['isSuccessful'] == false && data['code'] == 400) {
        debugPrint('wrong entry data');
        throw WrongDataException();
      } else {
        if (fromJson != null) {
          final resposeData = fromJson(data);
          return resposeData;
        } else {
          return data as T;
        }
      }
    } else {
      debugPrint('3');
      throw ServerException();
    }
  }
}
