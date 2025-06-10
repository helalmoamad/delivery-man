import 'package:dartz/dartz.dart';
import '../../models/Orders/list_order_model.dart';
import '../../repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class GetListOrderDataProvider {
  final OrdersRepository ordersRepository;

  GetListOrderDataProvider(this.ordersRepository);

  Future<Either<FailureDelivery, ListOrderModel>> call(
      {required String token,
      required String status,
      required int offset}) async {
    return await ordersRepository.getListOrderData(
        token: token, status: status, offset: offset);
  }
}
