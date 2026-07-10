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
    final categoriasJson = json['data'];

    return CategoriaPaginatedResponse(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? '',
      data: categoriasJson is List
          ? categoriasJson
                .whereType<Map<String, dynamic>>()
                .map(CategoriaData.fromJson)
                .toList()
          : const [],
      pagination: Pagination.fromJson(
        json['pagination'] is Map<String, dynamic>
            ? json['pagination'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
    );
  }
}
