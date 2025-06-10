import 'package:dartz/dartz.dart';
import 'package:delivery_man_app/TrydosChat/api/error/failures.dart';
import 'package:delivery_man_app/TrydosChat/chat_utils/use_case.dart';
import 'package:delivery_man_app/TrydosChat/domain/repositories/chat_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShareProductOnAppsUseCase
    extends UseCase<bool, ShareProductOnAppsParams> {
  final ChatRepository repository;

  ShareProductOnAppsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ShareProductOnAppsParams params) {
    return repository.shareProductOnApps(params.map);
  }
}

class ShareProductOnAppsParams {
  String appName;
  String productId;
  int sharedCount;

  ShareProductOnAppsParams({
    required this.appName,
    required this.productId,
    required this.sharedCount,
  });
  Map<String, dynamic> get map => {
        "app_name": "${appName}",
        "product_id": "${productId}",
        "shared_count": sharedCount,
      };
}
