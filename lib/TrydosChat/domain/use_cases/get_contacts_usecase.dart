import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/my_contacts_response_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class GetContactsUseCase extends UseCase<MyContactsResponseModel, NoParams> {
  final ChatRepository repository;

  GetContactsUseCase(this.repository);

  @override
  Future<Either<Failure, MyContactsResponseModel>> call(NoParams params) {
    return repository.getContacts();
  }
}
