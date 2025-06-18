import 'package:dartz/dartz.dart';
import '../../models/Orders/list_order_model.dart';
import '../../repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class GetMyOrdersForChatProvider {
  final OrdersRepository ordersRepository;

  GetMyOrdersForChatProvider(this.ordersRepository);

  Future<Either<FailureDelivery, GetOrderForChat>> call(
      {required String token, required String id, required int offset}) async {
    return await ordersRepository.getMyOrderDataForChatApi(
        token: token, id: id, offset: offset);
  }
}
