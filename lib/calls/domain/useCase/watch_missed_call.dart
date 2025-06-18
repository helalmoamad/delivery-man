import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart'
    show NoParams, UseCase;
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchMissedCallUseCase extends UseCase<bool, NoParams> {
  final CallsRepository repository;

  WatchMissedCallUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.watchMissedCall();
  }
}
