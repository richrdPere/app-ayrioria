import 'periodo_contable_data.dart';

class PeriodoContablePaginatedResponse {
  final bool success;
  final String message;
  final List<PeriodoContableData> data;
  final PeriodoPagination pagination;

  const PeriodoContablePaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory PeriodoContablePaginatedResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    /*
     * Formato esperado 1:
     *
     * {
     *   "success": true,
     *   "message": "...",
     *   "data": {
     *     "total": 20,
     *     "page": 1,
     *     "limit": 10,
     *     "totalPages": 2,
     *     "data": [...]
     *   }
     * }
     */
    if (rawData is Map<String, dynamic>) {
      final rawList = rawData['data'];

      return PeriodoContablePaginatedResponse(
        success: json['success'] == true,
        message: json['message']?.toString() ?? '',
        data: rawList is List
            ? rawList
                  .whereType<Map>()
                  .map(
                    (item) => PeriodoContableData.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList()
            : const [],
        pagination: PeriodoPagination(
          total: _parseInt(rawData['total']),
          page: _parseInt(rawData['page'], fallback: 1),
          limit: _parseInt(rawData['limit'], fallback: 10),
          totalPages: _parseInt(
            rawData['totalPages'] ?? rawData['total_pages'],
          ),
        ),
      );
    }

    /*
     * Formato esperado 2:
     *
     * {
     *   "success": true,
     *   "message": "...",
     *   "data": [...],
     *   "pagination": {...}
     * }
     */
    final rawPagination = json['pagination'];

    return PeriodoContablePaginatedResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: rawData is List
          ? rawData
                .whereType<Map>()
                .map(
                  (item) => PeriodoContableData.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      pagination: rawPagination is Map
          ? PeriodoPagination.fromJson(Map<String, dynamic>.from(rawPagination))
          : const PeriodoPagination(),
    );
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class PeriodoPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PeriodoPagination({
    this.total = 0,
    this.page = 1,
    this.limit = 10,
    this.totalPages = 0,
  });

  factory PeriodoPagination.fromJson(Map<String, dynamic> json) {
    return PeriodoPagination(
      total: _parseInt(json['total']),
      page: _parseInt(json['page'], fallback: 1),
      limit: _parseInt(json['limit'], fallback: 10),
      totalPages: _parseInt(json['totalPages'] ?? json['total_pages']),
    );
  }

  static int _parseInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
