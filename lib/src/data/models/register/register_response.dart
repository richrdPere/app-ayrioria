import 'package:app_aryoria/src/data/models/register/register_data_model.dart';

class RegisterResponse {
  final bool success;
  final String message;
  final RegisterDataModel data;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json["success"],
      message: json["message"],
      data: RegisterDataModel.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "message": message, "data": data.toJson()};
  }

  RegisterResponse copyWith({
    bool? success,
    String? message,
    RegisterDataModel? data,
  }) {
    return RegisterResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
