import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

class CategoriaResponse {
  final bool success;
  final String message;
  final CategoriaData? data;

  const CategoriaResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CategoriaResponse.fromJson(Map<String, dynamic> json) {
    final dynamic rawData = json['data'];

    return CategoriaResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData is Map<String, dynamic>
          ? CategoriaData.fromJson(rawData)
          : null,
    );
  }
}
