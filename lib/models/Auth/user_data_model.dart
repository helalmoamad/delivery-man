class UserModel {
  final String message;
  final UserDataModel data;

  UserModel({
    required this.message,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        message: json["message"],
        data: UserDataModel.fromJson(json["data"]),
      );
}

class UserDataModel {
  final int? userType;
  final String token;
  final String expiresAt;
  final User user;

  UserDataModel({
    required this.userType,
    required this.token,
    required this.expiresAt,
    required this.user,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        userType: json["user_type"],
        token: json["token"],
        expiresAt: json["expires_at"],
        user: User.fromJson(json["user"]),
      );
}

class User {
  final int? id;
  final String? name;
  final String? fName;
  final String? lName;
  final String? email;
  final String? deviceId;
  final String? phone;
  final String? countryDialCode;
  final String? gender;
  final String? birthdate;
  final int? isEmailVerified;
  final int? isPhoneVerified;
  final String? temporaryToken;
  final int? walletBalance;
  final String? walletBalanceFormatted;
  final String? image;
  final String? lastOtpIdToken;

  User({
    required this.id,
    required this.name,
    required this.fName,
    required this.lName,
    required this.email,
    required this.deviceId,
    required this.phone,
    required this.countryDialCode,
    required this.gender,
    required this.birthdate,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.temporaryToken,
    required this.walletBalance,
    required this.walletBalanceFormatted,
    required this.image,
    required this.lastOtpIdToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"] ?? '',
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        deviceId: json["device_id"],
        phone: json["phone"],
        countryDialCode: json["country_dial_code"],
        gender: json["gender"],
        birthdate: json["birthdate"],
        isEmailVerified: json["is_email_verified"],
        isPhoneVerified: json["is_phone_verified"],
        temporaryToken: json["temporary_token"],
        walletBalance: json["wallet_balance"],
        walletBalanceFormatted: json["wallet_balance_formatted"],
        image: json["image"],
        lastOtpIdToken: json["last_otp_id_token"] ?? '',
      );
}
