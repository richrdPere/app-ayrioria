import 'package:app_aryoria/src/data/models/common/pagination.dart';

import 'movimiento_data.dart';

class MovimientoPaginatedResponse {
  final bool success;
  final String message;
  final List<MovimientoData> data;
  final Pagination pagination;

  MovimientoPaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory MovimientoPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return MovimientoPaginatedResponse(
      success: json["success"],
      message: json["message"],
      data: (json["data"] as List)
          .map((e) => MovimientoData.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json["pagination"]),
    );
  }
}