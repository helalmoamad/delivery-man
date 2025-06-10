import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendErrorToServerUseCase extends UseCase<bool, SendErrorParams> {
  final ChatRepository repository;

  SendErrorToServerUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendErrorParams params) {
    return repository.SendErrorChatToServer(params.map);
  }
}

class SendErrorParams {
  String error;
  String pageName;

  SendErrorParams({required this.error, required this.pageName});
  Map<String, dynamic> get map =>
      {"error_description": error, "error_page": pageName};
}
