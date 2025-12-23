import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';

@injectable
class WatchMissedCallUseCase extends UseCase<bool, NoParams> {
  final CallsRepository repository;

  WatchMissedCallUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.watchMissedCall();
  }
}
