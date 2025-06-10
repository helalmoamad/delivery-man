abstract class FailureDelivery {}

//if no internet
class OfflineFailure extends FailureDelivery {}

//if data error from server
class ServerFailure extends FailureDelivery {}

// user insert wrong data in auth methods login or signup
class WrongDataFailure extends FailureDelivery {}

class CantAssignToVehicleFailure extends FailureDelivery {}

class ClientCloseFailure extends FailureDelivery {}

class UnExpectedFailure extends FailureDelivery {}

class OtpTryAgainFailure extends FailureDelivery {}
