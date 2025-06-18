import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/store_fcm_token_response_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class StoreFcmUseCase
    implements UseCase<StoreFcmTokenResponseModel, StoreFcmParams> {
  StoreFcmUseCase(this.repository);

  final ChatRepository repository;

  @override
  Future<Either<Failure, StoreFcmTokenResponseModel>> call(
      StoreFcmParams params) async {
    return repository.storeFcmToken(params.map);
  }
}

class StoreFcmParams {
  int userId;
  String fcmToken;

  StoreFcmParams({
    required this.userId,
    required this.fcmToken,
  });
  Map<String, dynamic> get map => {
        "data": {
          "user_id": userId,
          "token": fcmToken,
        },
      };
}
