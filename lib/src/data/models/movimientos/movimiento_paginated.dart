import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';

class MovimientoPaginated {
  final List<MovimientoData> items;
  final MovimientoPagination pagination;

  const MovimientoPaginated({required this.items, required this.pagination});

  factory MovimientoPaginated.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return MovimientoPaginated(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) =>
                      MovimientoData.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : <MovimientoData>[],

      pagination: json['pagination'] is Map
          ? MovimientoPagination.fromJson(
              Map<String, dynamic>.from(json['pagination']),
            )
          : const MovimientoPagination(),
    );
  }
}

class MovimientoPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const MovimientoPagination({
    this.total = 0,
    this.page = 1,
    this.limit = 10,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  factory MovimientoPagination.fromJson(Map<String, dynamic> json) {
    return MovimientoPagination(
      total: _toInt(json['total']),
      page: _toInt(json['page'], fallback: 1),
      limit: _toInt(json['limit'], fallback: 10),
      totalPages: _toInt(json['totalPages']),
      hasNextPage: json['hasNextPage'] == true,
      hasPreviousPage: json['hasPreviousPage'] == true,
    );
  }

  static int _toInt(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
