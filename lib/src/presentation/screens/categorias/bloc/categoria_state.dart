import 'package:equatable/equatable.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_response.dart';

class CategoriaState extends Equatable {
  /// Respuesta del listado paginado
  final Resource<CategoriaPaginatedResponse>? categoriaResponse;

  /// Respuesta de crear, actualizar y eliminar
  final Resource<CategoriaResponse>? actionResponse;

  /// Respuesta del detalle
  final Resource<CategoriaResponse>? detailResponse;

  /// Lista acumulada
  final List<CategoriaData> categorias;

  /// Paginación
  final int page;
  final int limit;
  final int totalPages;
  final int total;

  /// Búsqueda
  final String search;

  /// Estados de carga
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  const CategoriaState({
    this.categoriaResponse,
    this.actionResponse,
    this.detailResponse,
    this.categorias = const [],
    this.page = 1,
    this.limit = 10,
    this.totalPages = 0,
    this.total = 0,
    this.search = '',
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  CategoriaState copyWith({
    Resource<CategoriaPaginatedResponse>? categoriaResponse,
    Resource<CategoriaResponse>? actionResponse,
    Resource<CategoriaResponse>? detailResponse,
    List<CategoriaData>? categorias,
    int? page,
    int? limit,
    int? totalPages,
    int? total,
    String? search,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return CategoriaState(
      categoriaResponse: categoriaResponse ?? this.categoriaResponse,
      actionResponse: actionResponse ?? this.actionResponse,
      detailResponse: detailResponse ?? this.detailResponse,
      categorias: categorias ?? this.categorias,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      search: search ?? this.search,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    categoriaResponse,
    actionResponse,
    detailResponse,
    categorias,
    page,
    limit,
    totalPages,
    total,
    search,
    isLoading,
    isLoadingMore,
    hasMore,
  ];
}
