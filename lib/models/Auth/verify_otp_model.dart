// class VerifyOtpResponseModel {
//   final bool isSuccessful;
//   final bool hasContent;
//   final int code;
//   final String message;
//   final String? detailedError;
//   final VerifyOtpDataModel? data;

//   VerifyOtpResponseModel({
//     required this.isSuccessful,
//     required this.hasContent,
//     required this.code,
//     required this.message,
//     this.detailedError,
//     this.data,
//   });

//   factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
//     return VerifyOtpResponseModel(
//       isSuccessful: json['isSuccessful'],
//       hasContent: json['hasContent'],
//       code: json['code'],
//       message: json['message'],
//       detailedError: json['detailed_error'],
//       data: json['data'] != null
//           ? VerifyOtpDataModel.fromJson(json['data'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'isSuccessful': isSuccessful,
//       'hasContent': hasContent,
//       'code': code,
//       'message': message,
//       'detailed_error': detailedError,
//       'data': data?.toJson(),
//     };
//   }
// }

// class VerifyOtpDataModel {
//   final String phone;
//   final String idToken;

//   VerifyOtpDataModel({
//     required this.phone,
//     required this.idToken,
//   });

//   factory VerifyOtpDataModel.fromJson(Map<String, dynamic> json) {
//     return VerifyOtpDataModel(
//       phone: json['phone'],
//       idToken: json['id_token'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'phone': phone,
//       'id_token': idToken,
//     };
//   }
// }
class OtpVerificationResponse {
  final String? message;
  final String? idToken;
  final UserData? data;

  OtpVerificationResponse({
    this.message,
    this.idToken,
    this.data,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      message: json['message'],
      idToken: json['id_token'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final int? id;
  final String? mobilePhone;
  final String? username;
  final String? name;
  final String? photoPath;
  final String? email;
  final int? isLockedByAdminForDelete;
  final int? isLockedByAdminForUpdate;
  final String? updatedAt;
  final int? defaultLanguageId;
  final int? preferredCurrencyId;
  final int? citizenCountryId;
  final int? idNoRegionId;
  final int? assignToUserId;
  final String? countryForEmployee;
  final String? provinceForEmployee;
  final String? cityForEmployee;
  final String? workPhone;
  final int? verified;
  final String? lastActiveAt;
  final int? isBlockedByAdmin;
  final int? userStatusId;
  final int? numOfFailedAttempts;
  final String? postalCode;
  final int? canChangePassword;
  final String? fullName;
  final String? avatar;
  final String? surname;
  final String? birthdate;
  final String? address;
  final String? socialSecurityNumber;
  final String? websiteUrl;
  final String? facebookAccount;
  final String? instagramAccount;
  final String? defaultLanguage;
  final String? mobileVerifiedAt;
  final int? signupCountryId;
  final int? productsNumber;
  final int? servicesNumber;
  final String? city;
  final String? businessDocument;
  final String? firstName;
  final String? lastName;
  final String? storeName;
  final String? secondaryEmail;
  final String? whatsappNumber;
  final String? vatNumber;
  final String? companyContactPhoneNumber;
  final String? fullAddress;
  final int? isActive;
  final int? regionId;
  final int? managerId;
  final bool? isAdmin;
  final String? birthCountry;
  final String? passportNumber;
  final String? bankAccountDetails;
  final int? birthCityId;
  final String? idNo;
  final String? passportPhotoPath;
  final String? idPhotoPath;
  final String? idNoRegion;
  final int? passportRegionId;
  final String? drivingLicenseNo;
  final String? drivingLicensePhotoPath;
  final String? drivingLicenseRegion;
  final String? drivingLicenseIssuedFrom;
  final String? residence;
  final String? idIssuedFrom;
  final String? correlationId;
  final int? isAvailableForChat;
  final int? roleId;
  final String? passwordExpiredAt;
  final int? departmentRoleId;
  final String? accountStatus;
  final String? maskedEmail;
  final List<Role>? rolesArray;
  final String? maskedMobilePhone;
  final AssignedVehicle? assignedVehicle;
  final dynamic employee;
  final Role? currentRole;
  final String? authToken;

  UserData({
    this.id,
    this.mobilePhone,
    this.username,
    this.name,
    this.photoPath,
    this.email,
    this.isLockedByAdminForDelete,
    this.isLockedByAdminForUpdate,
    this.updatedAt,
    this.defaultLanguageId,
    this.preferredCurrencyId,
    this.citizenCountryId,
    this.idNoRegionId,
    this.assignToUserId,
    this.countryForEmployee,
    this.provinceForEmployee,
    this.cityForEmployee,
    this.workPhone,
    this.verified,
    this.lastActiveAt,
    this.isBlockedByAdmin,
    this.userStatusId,
    this.numOfFailedAttempts,
    this.postalCode,
    this.canChangePassword,
    this.fullName,
    this.avatar,
    this.surname,
    this.birthdate,
    this.address,
    this.socialSecurityNumber,
    this.websiteUrl,
    this.facebookAccount,
    this.instagramAccount,
    this.defaultLanguage,
    this.mobileVerifiedAt,
    this.signupCountryId,
    this.productsNumber,
    this.servicesNumber,
    this.city,
    this.businessDocument,
    this.firstName,
    this.lastName,
    this.storeName,
    this.secondaryEmail,
    this.whatsappNumber,
    this.vatNumber,
    this.companyContactPhoneNumber,
    this.fullAddress,
    this.isActive,
    this.regionId,
    this.managerId,
    this.isAdmin,
    this.birthCountry,
    this.passportNumber,
    this.bankAccountDetails,
    this.birthCityId,
    this.idNo,
    this.passportPhotoPath,
    this.idPhotoPath,
    this.idNoRegion,
    this.passportRegionId,
    this.drivingLicenseNo,
    this.drivingLicensePhotoPath,
    this.drivingLicenseRegion,
    this.drivingLicenseIssuedFrom,
    this.residence,
    this.idIssuedFrom,
    this.correlationId,
    this.isAvailableForChat,
    this.roleId,
    this.passwordExpiredAt,
    this.departmentRoleId,
    this.accountStatus,
    this.maskedEmail,
    this.rolesArray,
    this.maskedMobilePhone,
    this.assignedVehicle,
    this.employee,
    this.currentRole,
    this.authToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      mobilePhone: json['mobile_phone'],
      username: json['username'],
      name: json['name'],
      photoPath: json['photo_path'],
      email: json['email'],
      isLockedByAdminForDelete: json['is_locked_by_admin_for_delete'],
      isLockedByAdminForUpdate: json['is_locked_by_admin_for_update'],
      updatedAt: json['updated_at'],
      defaultLanguageId: json['default_language_id'],
      preferredCurrencyId: json['preferred_currency_id'],
      citizenCountryId: json['citizen_country_id'],
      idNoRegionId: json['id_no_region_id'],
      assignToUserId: json['assign_to_user_id'],
      countryForEmployee: json['country_for_employee'],
      provinceForEmployee: json['province_for_employee'],
      cityForEmployee: json['city_for_employee'],
      workPhone: json['work_phone'],
      verified: json['verified'],
      lastActiveAt: json['last_active_at'],
      isBlockedByAdmin: json['is_blocked_by_admin'],
      userStatusId: json['user_status_id'],
      numOfFailedAttempts: json['num_of_failed_attempts'],
      postalCode: json['postal_code'],
      canChangePassword: json['can_change_password'],
      fullName: json['full_name'],
      avatar: json['avatar'],
      surname: json['surname'],
      birthdate: json['birthdate'],
      address: json['address'],
      socialSecurityNumber: json['social_security_number'],
      websiteUrl: json['website_url'],
      facebookAccount: json['facebook_account'],
      instagramAccount: json['instagram_account'],
      defaultLanguage: json['default_language'],
      mobileVerifiedAt: json['mobile_verified_at'],
      signupCountryId: json['signup_country_id'],
      productsNumber: json['products_number'],
      servicesNumber: json['services_number'],
      city: json['city'],
      businessDocument: json['business_document'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      storeName: json['store_name'],
      secondaryEmail: json['secondary_email'],
      whatsappNumber: json['whatsapp_number'],
      vatNumber: json['vat_number'],
      companyContactPhoneNumber: json['company_contact_phone_number'],
      fullAddress: json['full_address'],
      isActive: json['is_active'],
      regionId: json['region_id'],
      managerId: json['manager_id'],
      isAdmin: json['is_admin'],
      birthCountry: json['birth_country'],
      passportNumber: json['passport_number'],
      bankAccountDetails: json['bank_account_details'],
      birthCityId: json['birth_city_id'],
      idNo: json['id_no'],
      passportPhotoPath: json['passport_photo_path'],
      idPhotoPath: json['id_photo_path'],
      idNoRegion: json['id_no_region'],
      passportRegionId: json['passport_region_id'],
      drivingLicenseNo: json['driving_license_no'],
      drivingLicensePhotoPath: json['driving_license_photo_path'],
      drivingLicenseRegion: json['driving_license_region'],
      drivingLicenseIssuedFrom: json['driving_license_issued_from'],
      residence: json['residence'],
      idIssuedFrom: json['id_issued_from'],
      correlationId: json['correlationId'],
      isAvailableForChat: json['is_available_for_chat'],
      roleId: json['role_id'],
      passwordExpiredAt: json['password_expired_at'],
      departmentRoleId: json['department_role_id'],
      accountStatus: json['account_status'],
      maskedEmail: json['masked_email'],
      rolesArray:
          (json['roles_array'] as List?)?.map((e) => Role.fromJson(e)).toList(),
      maskedMobilePhone: json['masked_mobile_phone'],
      assignedVehicle: json['assigned_vehicle'] != null
          ? AssignedVehicle.fromJson(json['assigned_vehicle'])
          : null,
      employee: json['employee'],
      currentRole: json['current_role'] != null
          ? Role.fromJson(json['current_role'])
          : null,
      authToken: json['auth_token'],
    );
  }
}

class AssignedVehicle {
  int? id;
  String? mobilePhone;
  String? username;
  String? name;
  String? photoPath;
  String? email;
  int? isLockedByAdminForDelete;
  int? isLockedByAdminForUpdate;
  String? updatedAt;
  int? defaultLanguageId;
  int? preferredCurrencyId;
  int? citizenCountryId;
  int? idNoRegionId;
  int? assignToUserId;
  String? countryForEmployee;
  String? provinceForEmployee;
  String? cityForEmployee;
  String? workPhone;
  int? verified;
  String? lastActiveAt;
  int? isBlockedByAdmin;
  int? userStatusId;
  int? numOfFailedAttempts;
  String? postalCode;
  int? canChangePassword;
  String? fullName;
  String? avatar;
  String? surname;
  String? birthdate;
  String? address;
  String? socialSecurityNumber;
  String? websiteUrl;
  String? facebookAccount;
  String? instagramAccount;
  String? defaultLanguage;
  String? mobileVerifiedAt;
  int? signupCountryId;
  int? productsNumber;
  int? servicesNumber;
  String? city;
  String? businessDocument;
  String? firstName;
  String? lastName;
  String? storeName;
  String? secondaryEmail;
  String? whatsappNumber;
  String? vatNumber;
  String? companyContactPhoneNumber;
  String? fullAddress;
  int? isActive;
  int? regionId;
  int? managerId;
  bool? isAdmin;
  String? birthCountry;
  String? passportNumber;
  String? bankAccountDetails;
  int? birthCityId;
  String? idNo;
  String? passportPhotoPath;
  String? idPhotoPath;
  String? idNoRegion;
  int? passportRegionId;
  String? drivingLicenseNo;
  String? drivingLicensePhotoPath;
  String? drivingLicenseRegion;
  String? drivingLicenseIssuedFrom;
  String? residence;
  String? idIssuedFrom;
  String? correlationId;
  int? isAvailableForChat;
  int? roleId;
  String? passwordExpiredAt;
  int? departmentRoleId;
  String? accountStatus;
  String? maskedEmail;
  List<Role>? rolesArray;
  String? maskedMobilePhone;
  dynamic employee;
  CurrentRole? currentRole;

  AssignedVehicle({
    this.id,
    this.mobilePhone,
    this.username,
    this.name,
    this.photoPath,
    this.email,
    this.isLockedByAdminForDelete,
    this.isLockedByAdminForUpdate,
    this.updatedAt,
    this.defaultLanguageId,
    this.preferredCurrencyId,
    this.citizenCountryId,
    this.idNoRegionId,
    this.assignToUserId,
    this.countryForEmployee,
    this.provinceForEmployee,
    this.cityForEmployee,
    this.workPhone,
    this.verified,
    this.lastActiveAt,
    this.isBlockedByAdmin,
    this.userStatusId,
    this.numOfFailedAttempts,
    this.postalCode,
    this.canChangePassword,
    this.fullName,
    this.avatar,
    this.surname,
    this.birthdate,
    this.address,
    this.socialSecurityNumber,
    this.websiteUrl,
    this.facebookAccount,
    this.instagramAccount,
    this.defaultLanguage,
    this.mobileVerifiedAt,
    this.signupCountryId,
    this.productsNumber,
    this.servicesNumber,
    this.city,
    this.businessDocument,
    this.firstName,
    this.lastName,
    this.storeName,
    this.secondaryEmail,
    this.whatsappNumber,
    this.vatNumber,
    this.companyContactPhoneNumber,
    this.fullAddress,
    this.isActive,
    this.regionId,
    this.managerId,
    this.isAdmin,
    this.birthCountry,
    this.passportNumber,
    this.bankAccountDetails,
    this.birthCityId,
    this.idNo,
    this.passportPhotoPath,
    this.idPhotoPath,
    this.idNoRegion,
    this.passportRegionId,
    this.drivingLicenseNo,
    this.drivingLicensePhotoPath,
    this.drivingLicenseRegion,
    this.drivingLicenseIssuedFrom,
    this.residence,
    this.idIssuedFrom,
    this.correlationId,
    this.isAvailableForChat,
    this.roleId,
    this.passwordExpiredAt,
    this.departmentRoleId,
    this.accountStatus,
    this.maskedEmail,
    this.rolesArray,
    this.maskedMobilePhone,
    this.employee,
    this.currentRole,
  });

  factory AssignedVehicle.fromJson(Map<String, dynamic> json) {
    return AssignedVehicle(
      id: json['id'],
      mobilePhone: json['mobile_phone'],
      username: json['username'],
      name: json['name'],
      photoPath: json['photo_path'],
      email: json['email'],
      isLockedByAdminForDelete: json['is_locked_by_admin_for_delete'],
      isLockedByAdminForUpdate: json['is_locked_by_admin_for_update'],
      updatedAt: json['updated_at'],
      defaultLanguageId: json['default_language_id'],
      preferredCurrencyId: json['preferred_currency_id'],
      citizenCountryId: json['citizen_country_id'],
      idNoRegionId: json['id_no_region_id'],
      assignToUserId: json['assign_to_user_id'],
      countryForEmployee: json['country_for_employee'],
      provinceForEmployee: json['province_for_employee'],
      cityForEmployee: json['city_for_employee'],
      workPhone: json['work_phone'],
      verified: json['verified'],
      lastActiveAt: json['last_active_at'],
      isBlockedByAdmin: json['is_blocked_by_admin'],
      userStatusId: json['user_status_id'],
      numOfFailedAttempts: json['num_of_failed_attempts'],
      postalCode: json['postal_code'],
      canChangePassword: json['can_change_password'],
      fullName: json['full_name'],
      avatar: json['avatar'],
      surname: json['surname'],
      birthdate: json['birthdate'],
      address: json['address'],
      socialSecurityNumber: json['social_security_number'],
      websiteUrl: json['website_url'],
      facebookAccount: json['facebook_account'],
      instagramAccount: json['instagram_account'],
      defaultLanguage: json['default_language'],
      mobileVerifiedAt: json['mobile_verified_at'],
      signupCountryId: json['signup_country_id'],
      productsNumber: json['products_number'],
      servicesNumber: json['services_number'],
      city: json['city'],
      businessDocument: json['business_document'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      storeName: json['store_name'],
      secondaryEmail: json['secondary_email'],
      whatsappNumber: json['whatsapp_number'],
      vatNumber: json['vat_number'],
      companyContactPhoneNumber: json['company_contact_phone_number'],
      fullAddress: json['full_address'],
      isActive: json['is_active'],
      regionId: json['region_id'],
      managerId: json['manager_id'],
      isAdmin: json['is_admin'],
      birthCountry: json['birth_country'],
      passportNumber: json['passport_number'],
      bankAccountDetails: json['bank_account_details'],
      birthCityId: json['birth_city_id'],
      idNo: json['id_no'],
      passportPhotoPath: json['passport_photo_path'],
      idPhotoPath: json['id_photo_path'],
      idNoRegion: json['id_no_region'],
      passportRegionId: json['passport_region_id'],
      drivingLicenseNo: json['driving_license_no'],
      drivingLicensePhotoPath: json['driving_license_photo_path'],
      drivingLicenseRegion: json['driving_license_region'],
      drivingLicenseIssuedFrom: json['driving_license_issued_from'],
      residence: json['residence'],
      idIssuedFrom: json['id_issued_from'],
      correlationId: json['correlationId'],
      isAvailableForChat: json['is_available_for_chat'],
      roleId: json['role_id'],
      passwordExpiredAt: json['password_expired_at'],
      departmentRoleId: json['department_role_id'],
      accountStatus: json['account_status'],
      maskedEmail: json['masked_email'],
      rolesArray:
          (json['roles_array'] as List?)?.map((e) => Role.fromJson(e)).toList(),
      maskedMobilePhone: json['masked_mobile_phone'],
      employee: json['employee'],
      currentRole: json['current_role'] != null
          ? CurrentRole.fromJson(json['current_role'])
          : null,
    );
  }
}

class Role {
  String? name;
  bool? isMain;

  Role({this.name, this.isMain});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json['name'],
      isMain: json['is_main'],
    );
  }
}

class CurrentRole {
  int? id;
  String? title;
  String? programmingName;
  String? programingName;
  int? isUsedInSystem;

  CurrentRole({
    this.id,
    this.title,
    this.programmingName,
    this.programingName,
    this.isUsedInSystem,
  });

  factory CurrentRole.fromJson(Map<String, dynamic> json) {
    return CurrentRole(
      id: json['id'],
      title: json['title'],
      programmingName: json['programming_name'],
      programingName: json['programing_name'],
      isUsedInSystem: json['is_used_in_system'],
    );
  }
}
