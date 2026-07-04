import 'package:app_aryoria/src/data/models/common/pagination.dart';
import 'empresa_data.dart';

class EmpresaPaginatedResponse {
  final bool success;
  final String message;
  final List<EmpresaData> data;
  final Pagination pagination;

  EmpresaPaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory EmpresaPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return EmpresaPaginatedResponse(
      success: json["success"],
      message: json["message"],
      data: (json["data"] as List).map((e) => EmpresaData.fromJson(e)).toList(),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }
}
