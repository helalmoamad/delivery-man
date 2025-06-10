import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/media_count.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMediaCountUseCase extends UseCase<MediaCount, GetMediaCountParams> {
  final ChatRepository repository;

  GetMediaCountUseCase(this.repository);

  @override
  Future<Either<Failure, MediaCount>> call(GetMediaCountParams params) {
    return repository.getMediaCount(params.map);
  }
}

class GetMediaCountParams {
  final String channelId;

  const GetMediaCountParams({required this.channelId});
  Map<String, dynamic> get map => {
        "id": channelId,
      };
}
