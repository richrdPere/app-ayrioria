import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';

class PeriodoContablePaginated {
  final List<PeriodoContableData> items;
  final PeriodoContablePagination pagination;

  const PeriodoContablePaginated({
    required this.items,
    required this.pagination,
  });

  factory PeriodoContablePaginated.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    final paginationJson = json['pagination'];

    return PeriodoContablePaginated(
      items: itemsJson is List
          ? itemsJson
                .whereType<Map<String, dynamic>>()
                .map(PeriodoContableData.fromJson)
                .toList()
          : <PeriodoContableData>[],
      pagination: paginationJson is Map<String, dynamic>
          ? PeriodoContablePagination.fromJson(paginationJson)
          : const PeriodoContablePagination(
              total: 0,
              page: 1,
              limit: 10,
              totalPages: 0,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
    );
  }

  factory PeriodoContablePaginated.empty() {
    return const PeriodoContablePaginated(
      items: [],
      pagination: PeriodoContablePagination(
        total: 0,
        page: 1,
        limit: 10,
        totalPages: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class PeriodoContablePagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PeriodoContablePagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PeriodoContablePagination.fromJson(Map<String, dynamic> json) {
    return PeriodoContablePagination(
      total: _toInt(json['total']),
      page: _toInt(json['page'], fallback: 1),
      limit: _toInt(json['limit'], fallback: 10),
      totalPages: _toInt(json['totalPages']),
      hasNextPage: _toBool(json['hasNextPage']),
      hasPreviousPage: _toBool(json['hasPreviousPage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
    };
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}
