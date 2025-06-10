import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteChatUseCase extends UseCase<bool, DeleteChatParams> {
  final ChatRepository repository;

  DeleteChatUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteChatParams params) {
    return repository.deleteChat(params.map);
  }
}

class DeleteChatParams {
  final String channelId;

  DeleteChatParams({
    required this.channelId,
  });
  Map<String, dynamic> get map => {
        "id": channelId,
      };
}
