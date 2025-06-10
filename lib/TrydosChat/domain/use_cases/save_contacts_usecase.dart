import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveContactsUseCase extends UseCase<bool, SaveContactsParams> {
  final ChatRepository repository;

  SaveContactsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveContactsParams params) {
    return repository.saveContacts(params.map);
  }
}

class SaveContactsParams {
  List<Map<String, dynamic>> contacts;

  SaveContactsParams({
    this.contacts = const [],
  });
  Map<String, dynamic> get map => {
        "contacts": contacts,
      };
}
