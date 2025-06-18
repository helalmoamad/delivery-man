import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/my_chats_response_model.dart'
    show ChatMessage;
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendMessageUseCase extends UseCase<ChatMessage, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, ChatMessage>> call(SendMessageParams params) {
    return repository.sendMessage(params.map);
  }
}

class SendMessageParams {
  final int? receiverUserId;
  final String? content;
  final List<Map<String, dynamic>>? mediaContent;
  final String? parentMessageId;
  final String? messageType;
  final bool? isForward;
  final double? imageWidth;
  final double? imageHeight;
  final Map<String, dynamic>? extraFields;

  SendMessageParams({
    this.receiverUserId,
    this.content,
    this.mediaContent,
    this.parentMessageId,
    this.messageType,
    this.isForward,
    this.extraFields,
    this.imageWidth,
    this.imageHeight,
  });
  Map<String, dynamic> get map => {
        "receiver_user_id": receiverUserId,
        "content": messageType != 'TextMessage' ? mediaContent : content,
        "parent_message_id": parentMessageId,
        "message_type": messageType,
        "is_forward": isForward,
        "extra_fields": extraFields,
        "image_original_width": imageWidth,
        "image_original_Height": imageHeight,
      };
}
