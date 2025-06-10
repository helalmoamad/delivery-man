import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart'
    show Failure;
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/result_of_search_text_in_chat_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchForMessageTextInChatUseCase extends UseCase<
    ResultOfSearchTextInChatModel, SearchForMessageTextInChatParams> {
  final ChatRepository repository;

  SearchForMessageTextInChatUseCase(this.repository);

  @override
  Future<Either<Failure, ResultOfSearchTextInChatModel>> call(
      SearchForMessageTextInChatParams params) {
    return repository.searchForMessageTextInChat(params.map);
  }
}

class SearchForMessageTextInChatParams {
  String channeltId;
  String searchText;
  String offset;

  SearchForMessageTextInChatParams(
      {required this.searchText,
      required this.channeltId,
      required this.offset});
  Map<String, dynamic> get map => {
        "channel_id": channeltId,
        "query": searchText,
        "limit": 10,
        "offset": offset
      };
}
