import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/agora_token_remote_response_model.dart';
import '../../data/models/make_call_response_model.dart';

@injectable
class GetAgoraTokenUseCase extends UseCase<GetAgoraTokenResponseModel, String> {
  final CallsRepository repository;

  GetAgoraTokenUseCase(this.repository);

  @override
  Future<Either<Failure, GetAgoraTokenResponseModel>> call(String ChatId) {
    return repository.getAgoraToken(ChatId: ChatId);
  }
}
