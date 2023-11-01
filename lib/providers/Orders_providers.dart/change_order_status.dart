import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class ChangeOrderStatusProvider {
  final OrdersRepository ordersRepository;

  ChangeOrderStatusProvider(this.ordersRepository);

  Future<Either<Failure, Unit>> call(
      {required String token,
      required String status,
      required int orderId,
      required int? amount,
      required String? file}) async {
    return await ordersRepository.changeStatus(
        token: token,
        orderId: orderId,
        file: file,
        status: status,
        amount: amount);
  }
}
