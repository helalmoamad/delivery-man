import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/cloudinary_url_routes.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/upload_file_cloudinary_response.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/common_use_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadFileCloudinaryUseCase extends UseCase<
    UploadFileCloudinaryResponseModel, UploadFileCloudinaryParams> {
  final CommonUseRepository repository;

  UploadFileCloudinaryUseCase(this.repository);

  @override
  Future<Either<Failure, UploadFileCloudinaryResponseModel>> call(
      UploadFileCloudinaryParams params) async {
    // TODO: implement call

    final Map<String, dynamic> map = await params.map();

    return repository.uploadFileCloudinary(map);
  }
}

class UploadFileCloudinaryParams {
  UploadFileCloudinaryParams(
      {required this.file,
      required this.usingOnUploadingFinishedFunction,
      required this.usingSendProgressFunction});

  File file;
  bool usingOnUploadingFinishedFunction;

  bool usingSendProgressFunction;

  Future<Map<String, dynamic>> map() async {
    var data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
      ),
      "upload_preset": CloudinaryUrls.LoadPreset
    });
    return {
      'data': data,
      'usingOnUploadingFinishedFunction': usingOnUploadingFinishedFunction,
      'usingSendProgressFunction': usingSendProgressFunction
    };
  }
}
