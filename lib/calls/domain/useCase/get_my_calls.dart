import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/calls/data/models/my_calls.dart';
import 'package:injectable/injectable.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';

@injectable
class GetMyCallsUseCase extends UseCase<MyCallsResponseModel, NoParams> {
  final CallsRepository repository;

  GetMyCallsUseCase(this.repository);

  @override
  Future<Either<Failure, MyCallsResponseModel>> call(NoParams params) {
    return repository.getmycalls();
  }
}
