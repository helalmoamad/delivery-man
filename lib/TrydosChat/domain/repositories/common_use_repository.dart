import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/data/models/upload_file_cloudinary_response.dart';

abstract class CommonUseRepository {
  Future<Either<Failure, UploadFileCloudinaryResponseModel>>
      uploadFileCloudinary(Map<String, dynamic> params);
}
