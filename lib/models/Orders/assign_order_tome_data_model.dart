class AssignOrderToMeDataModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final String? message;
  final String? detailedError;
  final AssignUnAssignOrderDataModel? data;

  AssignOrderToMeDataModel({
    required this.isSuccessful,
    required this.hasContent,
    required this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory AssignOrderToMeDataModel.fromJson(Map<String, dynamic> json) {
    return AssignOrderToMeDataModel(
      isSuccessful: json['isSuccessful'],
      hasContent: json['hasContent'],
      code: json['code'],
      message: json['message'] ?? '',
      detailedError: json['detailed_error'],
      data: json['data'] != null
          ? AssignUnAssignOrderDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class AssignUnAssignOrderDataModel {
  final bool? requiresConfirmation;
  final int? otherUnassignedCount;
  final List<int>? otherUnassignedOrderIds;
  final String? notificationMessage;

  AssignUnAssignOrderDataModel({
    required this.requiresConfirmation,
    required this.otherUnassignedCount,
    required this.otherUnassignedOrderIds,
    required this.notificationMessage,
  });

  factory AssignUnAssignOrderDataModel.fromJson(Map<String, dynamic> json) {
    return AssignUnAssignOrderDataModel(
      requiresConfirmation: json['requires_confirmation'],
      otherUnassignedCount: json['other_unassigned_count'] ?? 0,
      otherUnassignedOrderIds:
          List<int>.from(json['other_unassigned_order_ids'] ?? []),
      notificationMessage: json['notification_message'] ?? '',
    );
  }
}
