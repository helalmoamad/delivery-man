import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import '../../models/Orders/unassign_order_tome_model.dart';
import '../../shared/errors/failures.dart';

class UnAssignOrderToMeProvider {
  final OrdersRepository ordersRepository;

  UnAssignOrderToMeProvider(this.ordersRepository);

  Future<Either<Failure, UnAssignOrderToMeDataModel>> call(
      {required String token, required int orderId}) async {
    return await ordersRepository.unAssignOrderToMe(
        token: token, orderId: orderId);
  }
}
