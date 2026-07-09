import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/common/pagination.dart';

class CategoriaPaginatedResponse {
  final bool success;
  final String message;
  final List<CategoriaData> data;
  final Pagination pagination;

  CategoriaPaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory CategoriaPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return CategoriaPaginatedResponse(
      success: json["success"],
      message: json["message"],
      data: (json["data"] as List).map((e) => CategoriaData.fromJson(e)).toList(),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }
}
