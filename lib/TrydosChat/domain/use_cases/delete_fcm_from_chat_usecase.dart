import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteFcmFromChatUseCase implements UseCase<bool, DeleteFcmParams> {
  DeleteFcmFromChatUseCase(this.repository);

  final ChatRepository repository;

  @override
  Future<Either<Failure, bool>> call(DeleteFcmParams params) async {
    return repository.deleteFcmTokenFromChat(params.map);
  }
}

class DeleteFcmParams {
  String fcmToken;

  DeleteFcmParams({required this.fcmToken});
  Map<String, dynamic> get map => {"token": fcmToken};
}
