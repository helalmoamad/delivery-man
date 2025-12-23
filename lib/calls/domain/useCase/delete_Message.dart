import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';
import 'package:injectable/injectable.dart';


@injectable
class DeleteMessageUseCase extends UseCase<bool, DeleteMessageParams> {
  final CallsRepository repository;

  DeleteMessageUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(DeleteMessageParams params) {
    return repository.deleteMessage(params.map);
  }
}

class DeleteMessageParams {
  final String messageId;
  final int deleteFromAll;
  DeleteMessageParams({
    required this.deleteFromAll,
    required this.messageId,
  });
  Map<String, dynamic> get map =>
      {"id": messageId, "delete_for_all": deleteFromAll};
}
