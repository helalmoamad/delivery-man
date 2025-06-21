import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class UnAssignOrderToMeProvider {
  final OrdersRepository ordersRepository;

  UnAssignOrderToMeProvider(this.ordersRepository);

  Future<Either<FailureDelivery, AssignUnAssignOrderToMeDataModel>> call({
    required String token,
    required int orderId,
    required String note,
    required bool? confirm,
  }) async {
    return await ordersRepository.unAssignOrderToMe(
      token: token,
      orderId: orderId,
      note: note,
      confirm: confirm,
    );
  }
}
