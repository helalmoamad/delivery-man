import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class ChangeOrderReceivedAmountProvider {
  final OrdersRepository ordersRepository;

  ChangeOrderReceivedAmountProvider(this.ordersRepository);

  Future<Either<Failure, OrderModel>> call({
    required String token,
    required int orderId,
    required double receivedAmount,
  }) async {
    return await ordersRepository.changeOrderReceivedAmount(
      token: token,
      orderId: orderId,
      receivedAmount: receivedAmount,
    );
  }
}
