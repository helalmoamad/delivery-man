import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:injectable/injectable.dart';
import '../repositories/chat_repository.dart';

@injectable
class GetDateTimeUseCase extends UseCase<String, NoParams> {
  final ChatRepository repository;

  GetDateTimeUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repository.getDateTime();
  }
}
