import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

class CategoriaResponse {
  final bool success;
  final String message;
  final CategoriaData data;

  CategoriaResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoriaResponse.fromJson(Map<String, dynamic> json) {
    return CategoriaResponse(
      success: json["success"],
      message: json["message"],
      data: CategoriaData.fromJson(json["data"]),
    );
  }
}
