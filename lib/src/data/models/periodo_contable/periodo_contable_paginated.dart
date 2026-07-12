import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';

class PeriodoContablePaginatedResponse {
  final bool success;
  final String message;
  final List<PeriodoContableData> data;
  final PeriodoContablePagination pagination;

  const PeriodoContablePaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory PeriodoContablePaginatedResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> responseData =
        json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    final List<dynamic> periodosJson = responseData['periodos'] is List
        ? responseData['periodos'] as List<dynamic>
        : <dynamic>[];

    final Map<String, dynamic> paginationJson =
        responseData['pagination'] is Map<String, dynamic>
        ? responseData['pagination'] as Map<String, dynamic>
        : <String, dynamic>{};

    return PeriodoContablePaginatedResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: periodosJson
          .whereType<Map<String, dynamic>>()
          .map(PeriodoContableData.fromJson)
          .toList(),
      pagination: PeriodoContablePagination.fromJson(paginationJson),
    );
  }
}

class PeriodoContablePagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PeriodoContablePagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PeriodoContablePagination.fromJson(Map<String, dynamic> json) {
    return PeriodoContablePagination(
      total: _toInt(json['total']),
      page: _toInt(json['page'], fallback: 1),
      limit: _toInt(json['limit'], fallback: 10),
      totalPages: _toInt(json['totalPages'], fallback: 1),
    );
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
