import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReadAllMessagesUseCase extends UseCase<bool, ReadAllMessagesParams> {
  final ChatRepository repository;

  ReadAllMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ReadAllMessagesParams params) {
    return repository.readAllMessages(params.map);
  }
}

class ReadAllMessagesParams {
  final String channelId;

  ReadAllMessagesParams({
    required this.channelId,
  });
  Map<String, dynamic> get map => {
        "id": channelId,
      };
}
