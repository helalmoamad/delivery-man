class ChangeStatusModel {
  int? id;
  int? totalPrice;

  ChangeStatusModel({
    this.id,
    this.totalPrice,
  });

  factory ChangeStatusModel.fromJson(Map<String, dynamic> json) =>
      ChangeStatusModel(
        id: json["id"],
        totalPrice: json["total_price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total_price": totalPrice,
      };
}
