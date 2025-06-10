import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/my_chats_response_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareProductWithContactsOrChannelsUsecase
    extends UseCase<Message, ShareProductWithContactsOrChannelsParams> {
  final ChatRepository repository;

  ShareProductWithContactsOrChannelsUsecase(this.repository);

  @override
  Future<Either<Failure, Message>> call(
      ShareProductWithContactsOrChannelsParams params) {
    return repository.shareProductWithContactsOrChannels(params.map);
  }
}

class ShareProductWithContactsOrChannelsParams {
  final String productId;
  final String productName;
  final String productSlug;
  final String productDescription;
  final String productImageUrl;
  final List<String> channelIds;
  final List<int?> receiverIds;
  final String? productImageWidth;
  final String? productImageHeight;

  ShareProductWithContactsOrChannelsParams({
    required this.productId,
    required this.productName,
    required this.productSlug,
    required this.productDescription,
    required this.productImageUrl,
    required this.channelIds,
    required this.receiverIds,
    this.productImageWidth,
    this.productImageHeight,
  });

  Map<String, dynamic> get map => {
        'content': [
          {
            'product_id': productId,
            'product_slug': productSlug,
            'product_description': productDescription,
            'product_image_url': productImageUrl,
            'product_image_width': productImageWidth,
            'product_image_height': productImageHeight,
            'product_name': productName
          }
        ],
        'channel_ids': channelIds,
        'receiver_ids': receiverIds,
      };
}
