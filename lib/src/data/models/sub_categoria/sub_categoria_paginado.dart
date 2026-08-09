import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';

class SubcategoriaPaginated {
  final List<SubcategoriaData> data;

  final int total;
  final int page;
  final int limit;
  final int totalPages;

  final bool hasNextPage;
  final bool hasPreviousPage;

  const SubcategoriaPaginated({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory SubcategoriaPaginated.fromJson(Map<String, dynamic> json) {
    // ==========================================================
    // ITEMS
    // ==========================================================
    final rawItems = json['items'];

    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map(
                (item) =>
                    SubcategoriaData.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <SubcategoriaData>[];

    // ==========================================================
    // PAGINATION
    // ==========================================================
    final rawPagination = json['pagination'];

    final pagination = rawPagination is Map
        ? Map<String, dynamic>.from(rawPagination)
        : <String, dynamic>{};

    return SubcategoriaPaginated(
      data: items,
      total: _toInt(pagination['total']),
      page: _toInt(pagination['page'], fallback: 1),
      limit: _toInt(pagination['limit'], fallback: 10),
      totalPages: _toInt(pagination['total_pages']),
      hasNextPage: _toBool(pagination['has_next_page']),
      hasPreviousPage: _toBool(pagination['has_previous_page']),
    );
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static bool _toBool(dynamic value, {bool fallback = false}) {
    if (value is bool) {
      return value;
    }

    if (value == 1 || value == '1') {
      return true;
    }

    if (value == 0 || value == '0') {
      return false;
    }

    final normalized = value?.toString().trim().toLowerCase();

    if (normalized == 'true') {
      return true;
    }

    if (normalized == 'false') {
      return false;
    }

    return fallback;
  }
}
