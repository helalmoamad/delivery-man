import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReceiveMessageUseCase extends UseCase<bool, ReceiveMessageParams> {
  final ChatRepository repository;

  ReceiveMessageUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReceiveMessageParams params) {
    return repository.receiveMessage(params.map);
  }
}

class ReceiveMessageParams {
  final String channelId;

  ReceiveMessageParams({
    required this.channelId,
  });
  Map<String, dynamic> get map => {
        "id": channelId,
      };
}
