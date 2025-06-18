import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AnswerCallUseCase extends UseCase<bool, String> {
  final CallsRepository repository;

  AnswerCallUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String messageId) {
    return repository.answerCall(messageId);
  }
}
