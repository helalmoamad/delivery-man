import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/calls/domain/repositories/calls_repository.dart';

@injectable
class RejectCallUseCase extends UseCase<bool, RejectCallParams> {
  final CallsRepository repository;

  RejectCallUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(RejectCallParams params) {
    return repository.rejectCall(params.map);
  }
}

class RejectCallParams {
  final String messageId;
  final Map<String, dynamic>? payload;
  final int duration;

  const RejectCallParams(
      {required this.messageId, this.payload, required this.duration});

  Map<String, dynamic> get map => {
        'messageId': messageId,
        'payload': {'payload': payload, "duration_in_seconds": duration}
      };
}
