import 'empresa_data.dart';

class EmpresaResponse {
  final bool success;
  final String message;
  final EmpresaData data;

  EmpresaResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EmpresaResponse.fromJson(Map<String, dynamic> json) {
    return EmpresaResponse(
      success: json["success"],
      message: json["message"],
      data: EmpresaData.fromJson(json["data"]),
    );
  }
}
