class OfflineException implements Exception {}

class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

class WrongDataException implements Exception {
  final String? message;
  WrongDataException([this.message]);
}

class CantAssignToVehicleException implements Exception {
  final String? message;
  CantAssignToVehicleException([this.message]);
}

class OtpTryAgainException implements Exception {
  final String? message;
  OtpTryAgainException([this.message]);
}