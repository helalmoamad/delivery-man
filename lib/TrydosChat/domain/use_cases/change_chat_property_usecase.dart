import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/change_chat_property_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeChatPropertyUseCase
    extends UseCase<ChangeChatPropertyModel, ChangeChatPropertyParams> {
  final ChatRepository repository;

  ChangeChatPropertyUseCase(this.repository);

  @override
  Future<Either<Failure, ChangeChatPropertyModel>> call(
      ChangeChatPropertyParams params) {
    return repository.changeChatProperty(params.map);
  }
}

class ChangeChatPropertyParams {
  final String channelId;
  final int? mute;
  final int? pin;
  final int? archive;

  ChangeChatPropertyParams(
      {required this.channelId, this.archive, this.mute, this.pin});
  Map<String, dynamic> get map => {
        "channel_id": channelId,
        "archived": archive,
        "pin": pin,
        "mute": mute,
      };
}
