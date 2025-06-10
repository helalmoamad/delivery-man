import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileInChatUseCase
    extends UseCase<bool, UpdateProfileInChatParams> {
  final ChatRepository repository;

  UpdateProfileInChatUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateProfileInChatParams params) {
    return repository.updateProfileInChat(params.map);
  }
}

class UpdateProfileInChatParams {
  final String userId;
  final String name;
  final String phone;
  final String photo;
  UpdateProfileInChatParams({
    required this.userId,
    required this.phone,
    required this.photo,
    required this.name,
  });
  Map<String, dynamic> get map =>
      {"id": userId, "name": name, "mobile_phone": phone, "photo_path": photo};
}
