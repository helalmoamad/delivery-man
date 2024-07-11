import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/RequestInfo/request_info_model.dart';
import '../../shared/errors/exceptions.dart';
import '../../shared/global_functions/global_functions.dart';
import 'background_api_constants.dart';

class OrderNetworkApi {
  Future<Unit> uploadFileApi({
    required String token,
    required int orderId,
    required String file,
  }) async {
    final uri = Uri.parse(
        '${BackgroundApiConstants.baseUrl}/api/${BackgroundApiConstants.version}/orders/upload_file');

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    request.files.add(await http.MultipartFile.fromPath('file', file));

    request.fields['order_id'] = orderId.toString();

    debugPrint('1');

    var response = await request.send();
    debugPrint(response.statusCode.toString());
    final res = await response.stream.transform(utf8.decoder).first;
    /////////////////store request info//////////////////////////////////
    final data = RequestInfoModel(
        url: uri.toString(),
        requestType: 'POST',
        token: token,
        header: response.headers.toString(),
        body: request.fields.toString(),
        response: res.toString());

    await GlobalFunctions.setLocalStorageData(
      infoData: data,
      fromJson: RequestInfoModel.fromJson,
      key: 'requestsInfo',
      maxNumberOfData: 100,
    );
    //////////////////////////////////////////////////////////////////
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('2');
      debugPrint('UploadFile Success');
      return Future.value(unit);
    } else {
      debugPrint('3');
      debugPrint(res.toString());
      debugPrint('UploadFile Failed');
      throw ServerException();
    }
  }
}
