class AssignUnAssignOrderToMeDataModel {
  final bool? isSuccessful;
  final bool? hasContent;
  final int? code;
  final String? message;
  final String? detailedError;
  final AssignUnAssignOrderDataModel? data;

  AssignUnAssignOrderToMeDataModel({
    required this.isSuccessful,
    required this.hasContent,
    required this.code,
    this.message,
    this.detailedError,
    this.data,
  });

  factory AssignUnAssignOrderToMeDataModel.fromJson(Map<String, dynamic> json) {
    return AssignUnAssignOrderToMeDataModel(
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
  final int? otherAssignedCount;
  final List<int>? otherUnassignedOrderIds;
  final List<int>? otherAssignedOrderIds;
  final String? notificationMessage;

  AssignUnAssignOrderDataModel({
    required this.requiresConfirmation,
    required this.otherUnassignedCount,
    required this.otherAssignedCount,
    required this.otherUnassignedOrderIds,
    required this.otherAssignedOrderIds,
    required this.notificationMessage,
  });

  factory AssignUnAssignOrderDataModel.fromJson(Map<String, dynamic> json) {
    return AssignUnAssignOrderDataModel(
      requiresConfirmation: json['requires_confirmation'],
      otherUnassignedCount: json['other_unassigned_count'] ?? 0,
      otherAssignedCount: json['other_assigned_count'] ?? 0,
      otherUnassignedOrderIds:
          List<int>.from(json['other_unassigned_order_ids'] ?? []),
      otherAssignedOrderIds:
          List<int>.from(json['other_assigned_order_ids'] ?? []),
      notificationMessage: json['notification_message'] ?? '',
    );
  }
}
