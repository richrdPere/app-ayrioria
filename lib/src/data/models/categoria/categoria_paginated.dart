import 'categoria_data.dart';

class CategoriaPaginated {
  final List<CategoriaData> items;
  final CategoriaPagination pagination;

  const CategoriaPaginated({required this.items, required this.pagination});

  factory CategoriaPaginated.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];

    final paginationJson = json['pagination'];

    return CategoriaPaginated(
      items: itemsJson is List
          ? itemsJson
                .whereType<Map<String, dynamic>>()
                .map(CategoriaData.fromJson)
                .toList()
          : <CategoriaData>[],
      pagination: paginationJson is Map<String, dynamic>
          ? CategoriaPagination.fromJson(paginationJson)
          : const CategoriaPagination(
              total: 0,
              page: 1,
              limit: 10,
              totalPages: 0,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
    );
  }

  factory CategoriaPaginated.empty() {
    return const CategoriaPaginated(
      items: [],
      pagination: CategoriaPagination(
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

class CategoriaPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const CategoriaPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory CategoriaPagination.fromJson(Map<String, dynamic> json) {
    return CategoriaPagination(
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

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return false;
  }
}
