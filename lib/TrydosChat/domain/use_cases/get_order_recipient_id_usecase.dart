import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/get_order_recipient_id_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOrderRecipientIdUseCase
    extends UseCase<GetOrderRecipientIdModel, GetOrderRecipientIdParams> {
  final ChatRepository repository;

  GetOrderRecipientIdUseCase(this.repository);

  @override
  Future<Either<Failure, GetOrderRecipientIdModel>> call(
      GetOrderRecipientIdParams params) {
    return repository.getOrderRecipientId(params.map);
  }
}

class GetOrderRecipientIdParams {
  final String? orderId;
  final String? originalUserId;
  const GetOrderRecipientIdParams({this.orderId, this.originalUserId});

  Map<String, dynamic> get map => {
        'order_id': orderId,
        'delivery_user_id': originalUserId,
      };
}
