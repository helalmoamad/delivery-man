
import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/models/Orders/listDirectOrder.dart';
import 'package:delivery_man_app/models/Orders/list_order_model.dart';
import 'package:delivery_man_app/repositories/order_repository.dart';
import 'package:delivery_man_app/shared/errors/failures.dart';

class GetAllMyOrderDataProvider {
  final OrdersRepository ordersRepository;

  GetAllMyOrderDataProvider(this.ordersRepository);

  Future<Either<FailureDelivery, MyOrdersResponse>> call(
      {required String token,}) async {
    return await ordersRepository.getAllMyOrderData(
        token: token);
  }
}