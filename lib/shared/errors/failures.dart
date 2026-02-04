abstract class FailureDelivery {
  final String? message;
  FailureDelivery([this.message]);
}

//if no internet
class OfflineFailure extends FailureDelivery {
  OfflineFailure([super.message]);
}

//if data error from server
class ServerFailure extends FailureDelivery {
  ServerFailure([super.message]);
}

// user insert wrong data in auth methods login or signup
class WrongDataFailure extends FailureDelivery {
  WrongDataFailure([super.message]);
}

class CantAssignToVehicleFailure extends FailureDelivery {
  CantAssignToVehicleFailure([super.message]);
}

class ClientCloseFailure extends FailureDelivery {
  ClientCloseFailure([super.message]);
}

class UnExpectedFailure extends FailureDelivery {
  UnExpectedFailure([super.message]);
}

class OtpTryAgainFailure extends FailureDelivery {
  OtpTryAgainFailure([super.message]);
}