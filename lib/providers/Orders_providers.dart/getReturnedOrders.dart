import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/repositories/order_repository.dart' show OrdersRepository;
import 'package:delivery_man_app/shared/errors/failures.dart';

class GetListReturnedOrderDataProvider {
  final OrdersRepository ordersRepository;

  GetListReturnedOrderDataProvider(this.ordersRepository);

  Future<Either<FailureDelivery, ListOrderModel>> call(
      {required String token,
      required String status,
      required int offset}) async {
    return await ordersRepository.getListReturnedOrderData(
        token: token, status: status, offset: offset);
  }
}