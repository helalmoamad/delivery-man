import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class EndCallUseCase extends UseCase<bool, EndCallParams> {
  final CallsRepository repository;
  EndCallUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(EndCallParams params) {
    return repository.endCall(params.map);
  }
}

class EndCallParams {
  final String userId;

  EndCallParams({required this.userId});

  Map<String, dynamic> get map => {"user_id": userId};
}
