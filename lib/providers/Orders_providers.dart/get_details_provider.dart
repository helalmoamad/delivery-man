import 'package:dartz/dartz.dart';
import '../../models/Orders/update_order_response_model.dart';
import '../../repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class GetOrderDetailsProvider {
  final OrdersRepository orderRepository;

  GetOrderDetailsProvider(this.orderRepository);

  Future<Either<FailureDelivery, UpdateOrderResponseModel>> call({
    required String token,
    required int orderId,
  }) async {
    return await orderRepository.getOrderDetails(
      token: token,
      orderId: orderId,
    );
  }
}
