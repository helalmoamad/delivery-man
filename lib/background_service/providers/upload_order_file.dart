import 'package:dartz/dartz.dart';

import '../../shared/errors/failures.dart';
import '../repositories/order_background_repository.dart';

class UploadFileProvider {
  final OrderBackGroundRepository orderBackGroundRepository;

  UploadFileProvider(this.orderBackGroundRepository);

  Future<Either<Failure, Unit>> call({
    required String token,
    required int orderId,
    required String file,
  }) async {
    return await orderBackGroundRepository.uploadFile(
      token: token,
      orderId: orderId,
      file: file,
    );
  }
}
