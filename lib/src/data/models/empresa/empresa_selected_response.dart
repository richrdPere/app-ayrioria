import 'empresa_data.dart';

class EmpresaSelectedResponse {
  final bool success;
  final String message;
  final EmpresaSelectedData data;

  EmpresaSelectedResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EmpresaSelectedResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmpresaSelectedResponse(
      success: json["success"],
      message: json["message"],
      data: EmpresaSelectedData.fromJson(json["data"]),
    );
  }
}



class EmpresaSelectedData {
  final String token;
  final EmpresaData empresa;

  EmpresaSelectedData({
    required this.token,
    required this.empresa,
  });

  factory EmpresaSelectedData.fromJson(
    Map<String, dynamic> json,
  ) {
    return EmpresaSelectedData(
      token: json["token"],
      empresa: EmpresaData.fromJson(json["empresa"]),
    );
  }
}