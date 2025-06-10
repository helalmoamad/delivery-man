import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/my_chats_response_model.dart';

@injectable
class GetMessagesForChatUseCase
    extends UseCase<List<Message>, GetMessagesForChatParams> {
  final ChatRepository repository;

  GetMessagesForChatUseCase(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(GetMessagesForChatParams params) {
    return repository.getMessagesForChat(params.map);
  }
}

class GetMessagesForChatParams {
  final int lastMessageId;
  final int limit;
  final String channelId;
  const GetMessagesForChatParams({
    required this.lastMessageId,
    required this.limit,
    required this.channelId,
  });
  Map<String, dynamic> get map => {
        'data': {"message_id": lastMessageId, "limit": limit},
        'params': channelId
      };
}
