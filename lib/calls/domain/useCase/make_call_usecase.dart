import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart'
    show UseCase;
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/make_call_response_model.dart';

@injectable
class MakeCallUseCase
    extends UseCase<MakeCallRemoteResponseModel, MakeCallParams> {
  final CallsRepository repository;

  MakeCallUseCase(this.repository);

  @override
  Future<Either<Failure, MakeCallRemoteResponseModel>> call(
      MakeCallParams params) {
    return repository.makeCall(params: params.map);
  }
}

class MakeCallParams {
  final String? chatId;
  final String? receiverUserId;
  final Map<String, dynamic> payload;
  final bool isVideo;
  const MakeCallParams({
    this.chatId,
    this.receiverUserId,
    required this.isVideo,
    required this.payload,
  });

  Map<String, dynamic> get map => {
        "data": {
          "payload": payload,
          "channel_id": chatId,
          "receiver_user_id": receiverUserId,
        },
        "isVideo": isVideo,
      };
}
