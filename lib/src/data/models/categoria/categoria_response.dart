import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

class CategoriaResponse {
  final List<CategoriaData> categorias;
  final CategoriaPagination pagination;

  const CategoriaResponse({required this.categorias, required this.pagination});

  factory CategoriaResponse.fromJson(Map<String, dynamic> json) {
    return CategoriaResponse(
      categorias: (json['categorias'] as List<dynamic>? ?? [])
          .map((e) => CategoriaData.fromJson(e))
          .toList(),
      pagination: CategoriaPagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categorias': categorias.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  CategoriaResponse copyWith({
    List<CategoriaData>? categorias,
    CategoriaPagination? pagination,
  }) {
    return CategoriaResponse(
      categorias: categorias ?? this.categorias,
      pagination: pagination ?? this.pagination,
    );
  }
}

class CategoriaPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const CategoriaPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory CategoriaPagination.fromJson(Map<String, dynamic> json) {
    return CategoriaPagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }

  CategoriaPagination copyWith({
    int? total,
    int? page,
    int? limit,
    int? totalPages,
  }) {
    return CategoriaPagination(
      total: total ?? this.total,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
