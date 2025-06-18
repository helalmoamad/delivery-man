import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/api/handling_exception.dart';
import 'package:delivery_man_app/TrydosChat/data/data_sources/common_use_repo_data_source.dart';
import 'package:delivery_man_app/TrydosChat/data/models/upload_file_cloudinary_response.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/common_use_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommonUseRepository)
class CommonUseRepositoryImpl extends CommonUseRepository
    with HandlingExceptionRequest {
  final CommonUseRemoteDataSource commonUseRemoteDataSource;

  CommonUseRepositoryImpl(this.commonUseRemoteDataSource);

  @override
  Future<Either<Failure, UploadFileCloudinaryResponseModel>>
      uploadFileCloudinary(Map<String, dynamic> params) {
    return handlingExceptionRequest(
        tryCall: () => commonUseRemoteDataSource.uploadCloudinaryFile(params));
  }
}
