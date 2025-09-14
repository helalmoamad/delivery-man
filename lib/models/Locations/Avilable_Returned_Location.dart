class AvailableReturnLocation {
  int? id;
  String? countryIso;
  int? originalLocationId;
  int? sellerId;
  String? name;
  String? address;
  int? status;
  String? latitude;
  String? longitude;
  String? province;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  AvailableReturnLocation({
    this.id,
    this.countryIso,
    this.originalLocationId,
    this.sellerId,
    this.name,
    this.address,
    this.status,
    this.latitude,
    this.longitude,
    this.province,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory AvailableReturnLocation.fromJson(Map<String, dynamic> json) {
    return AvailableReturnLocation(
      id: json['id'],
      countryIso: json['country_iso'],
      originalLocationId: json['original_location_id'],
      sellerId: json['seller_id'],
      name: json['name'],
      address: json['address'],
      status: json['status'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      province: json['province'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "country_iso": countryIso,
      "original_location_id": originalLocationId,
      "seller_id": sellerId,
      "name": name,
      "address": address,
      "status": status,
      "latitude": latitude,
      "longitude": longitude,
      "province": province,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "deleted_at": deletedAt,
    };
  }
}
