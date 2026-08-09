import 'empresa_data.dart';

class EmpresaPaginated {
  final List<EmpresaData> data;

  final int total;
  final int page;
  final int limit;
  final int totalPages;

  EmpresaPaginated({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory EmpresaPaginated.fromJson(Map<String, dynamic> json) {
    // ==========================================================
    // ITEMS
    // ==========================================================
    final rawItems = json['items'];

    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map(
                (item) => EmpresaData.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : <EmpresaData>[];

    // ==========================================================
    // PAGINATION
    // ==========================================================
    final rawPagination = json['pagination'];

    final pagination = rawPagination is Map
        ? Map<String, dynamic>.from(rawPagination)
        : <String, dynamic>{};

    return EmpresaPaginated(
      data: items,
      total: _toInt(pagination['total']),
      page: _toInt(pagination['page'], fallback: 1),
      limit: _toInt(pagination['limit'], fallback: 10),
      totalPages: _toInt(pagination['totalPages']),
    );
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
