import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';

class SubcategoriaPaginated {
  final List<SubcategoriaData> data;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const SubcategoriaPaginated({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory SubcategoriaPaginated.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    final items = rawData is List
        ? rawData
              .whereType<Map<String, dynamic>>()
              .map(SubcategoriaData.fromJson)
              .toList()
        : <SubcategoriaData>[];

    return SubcategoriaPaginated(
      data: items,
      total: _toInt(json['total'] ?? json['totalItems'] ?? json['total_items']),
      page: _toInt(
        json['page'] ?? json['currentPage'] ?? json['current_page'],
        fallback: 1,
      ),
      limit: _toInt(json['limit'], fallback: 10),
      totalPages: _toInt(json['totalPages'] ?? json['total_pages']),
    );
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
