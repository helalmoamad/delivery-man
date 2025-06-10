import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class ChangeOrderStatusProvider {
  final OrdersRepository ordersRepository;

  ChangeOrderStatusProvider(this.ordersRepository);

  Future<Either<FailureDelivery, Unit>> call({
    required String token,
    required String status,
    required int orderId,
    required double? amount,
    required String? note,
    required List<ProductModel>? returnedProducts,
  }) async {
    return await ordersRepository.changeStatus(
      token: token,
      orderId: orderId,
      status: status,
      returnedProducts: returnedProducts,
      amount: amount,
      note: note,
    );
  }
}
