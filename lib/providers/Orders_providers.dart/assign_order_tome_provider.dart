import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/assign_order_tome_data_model.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import '../../shared/errors/failures.dart';

class AssignOrderToMeProvider {
  final OrdersRepository ordersRepository;

  AssignOrderToMeProvider(this.ordersRepository);

  Future<Either<Failure, AssignOrderToMeDataModel>> call(
      {required String token,
      required int orderId,
      required bool? confirm}) async {
    return await ordersRepository.assignOrderToMe(
      token: token,
      orderId: orderId,
      confirm: confirm,
    );
  }
}
