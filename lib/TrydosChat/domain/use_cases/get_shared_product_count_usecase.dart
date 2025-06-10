import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/data/models/shared_product_count_model.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSharedProductCountUseCase
    extends UseCase<GetSharedProductCountModel, GetSharedProductCountParams> {
  final ChatRepository repository;

  GetSharedProductCountUseCase(this.repository);

  @override
  Future<Either<Failure, GetSharedProductCountModel>> call(
      GetSharedProductCountParams params) {
    return repository.getSharedProductCount(params.map);
  }
}

class GetSharedProductCountParams {
  final String productId;

  const GetSharedProductCountParams({required this.productId});
  Map<String, dynamic> get map => {
        "id": productId,
      };
}
