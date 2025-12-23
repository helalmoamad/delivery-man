import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/calls/data/models/missed_call_count.dart';
import 'package:injectable/injectable.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';

@injectable
class GetMissedCalCountUseCase extends UseCase<MissedCallCountModel, NoParams> {
  final CallsRepository repository;

  GetMissedCalCountUseCase(this.repository);

  @override
  Future<Either<Failure, MissedCallCountModel>> call(NoParams params) {
    return repository.getMissedCallCount();
  }
}
