import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';

class SubcategoriaPaginated {
  final List<SubcategoriaData> items;
  final SubcategoriaPagination pagination;

  const SubcategoriaPaginated({
    required this.items,
    required this.pagination,
  });

  factory SubcategoriaPaginated.fromJson(Map<String, dynamic> json) {
    return SubcategoriaPaginated(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => SubcategoriaData.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      pagination: SubcategoriaPagination.fromJson(
        Map<String, dynamic>.from(
          json['pagination'] ?? {},
        ),
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

class SubcategoriaPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const SubcategoriaPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory SubcategoriaPagination.fromJson(Map<String, dynamic> json) {
    return SubcategoriaPagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['total_pages'] ?? 0,
      hasNextPage: json['has_next_page'] ?? false,
      hasPreviousPage: json['has_previous_page'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'total_pages': totalPages,
      'has_next_page': hasNextPage,
      'has_previous_page': hasPreviousPage,
    };
  }
}