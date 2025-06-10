import 'package:dartz/dartz.dart';
import '../../repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class GetOrderStatusDataProvider {
  final OrdersRepository ordersRepository;

  GetOrderStatusDataProvider(this.ordersRepository);

  Future<Either<FailureDelivery, List<dynamic>>> call({
    required String token,
  }) async {
    return await ordersRepository.getOrderStatusData(token: token);
  }
}
