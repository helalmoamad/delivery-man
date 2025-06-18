import 'package:delivery_man_app/TrydosChat/chat_utils/list_ex.dart';
import 'package:delivery_man_app/TrydosChat/data/models/my_chats_response_model.dart';

MergeOldMessageWithNew({
  required List<Chat> newChats,
  required List<Chat> previousChats,
}) {
  List<ChatMessage> currMessages;
  List<ChatMessage> prevMessages;
  List<ChatMessage> resultMessages = [];
  List<Chat> emptyChats = [];
  for (var chat in previousChats) {
    if (chat.messages.isNullOrEmpty &&
        int.tryParse(chat.id.toString()) == null) {
      emptyChats.add(chat);
    }
  }
  return (previousChats.isNotEmpty &&
          previousChats
              .any((element) => int.tryParse(element.id.toString()) != null))
      ? [
          ...newChats.map((chat) {
            prevMessages = List.of(previousChats
                    .firstWhere((element) => element.id == chat.id,
                        orElse: () => Chat())
                    .messages ??
                []);
            resultMessages = [];
            for (int i = 0; i < prevMessages.length; i++) {
              if (int.tryParse(prevMessages[i].id.toString()) == null) {
                resultMessages.add(prevMessages[i]);
                prevMessages.removeAt(i);
              }
            }
            if (prevMessages.isEmpty) {
              return chat;
            }
            currMessages = List.of(chat.messages ?? []);
            resultMessages.addAll(currMessages);
            for (int i = 20; i < prevMessages.length; i++) {
              resultMessages.add(prevMessages[i]);
            }
            resultMessages.sort(
              (a, b) {
                return b.createdAt!.compareTo(a.createdAt!);
              },
            );
            return chat.copyWith(messages: resultMessages);
          }).toList(),
          ...emptyChats
        ]
      : newChats;
}
