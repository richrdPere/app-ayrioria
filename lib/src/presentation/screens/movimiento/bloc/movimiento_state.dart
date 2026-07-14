import 'package:equatable/equatable.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';

class MovimientoState extends Equatable {
  final Resource<MovimientoPaginatedResponse>? movimientoResponse;
  final Resource<MovimientoResponse>? actionResponse;
  final Resource<MovimientoResponse>? detailResponse;

  final List<MovimientoData> movimientos;

  final int? idEmpresa;
  final int? idPeriodo;

  final int page;
  final int limit;
  final int totalPages;
  final int total;

  final String search;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  const MovimientoState({
    this.movimientoResponse,
    this.actionResponse,
    this.detailResponse,
    this.movimientos = const [],
    this.idEmpresa,
    this.idPeriodo,
    this.page = 1,
    this.limit = 10,
    this.totalPages = 0,
    this.total = 0,
    this.search = '',
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  MovimientoState copyWith({
    Resource<MovimientoPaginatedResponse>? movimientoResponse,
    Resource<MovimientoResponse>? actionResponse,
    Resource<MovimientoResponse>? detailResponse,
    List<MovimientoData>? movimientos,
    int? idEmpresa,
    int? idPeriodo,
    int? page,
    int? limit,
    int? totalPages,
    int? total,
    String? search,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    bool clearMovimientoResponse = false,
    bool clearActionResponse = false,
    bool clearDetailResponse = false,
    bool clearIdEmpresa = false,
    bool clearIdPeriodo = false,
  }) {
    return MovimientoState(
      movimientoResponse: clearMovimientoResponse
          ? null
          : movimientoResponse ?? this.movimientoResponse,
      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,
      detailResponse: clearDetailResponse
          ? null
          : detailResponse ?? this.detailResponse,
      movimientos: movimientos ?? this.movimientos,
      idEmpresa: clearIdEmpresa ? null : idEmpresa ?? this.idEmpresa,
      idPeriodo: clearIdPeriodo ? null : idPeriodo ?? this.idPeriodo,
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
    movimientoResponse,
    actionResponse,
    detailResponse,
    movimientos,
    idEmpresa,
    idPeriodo,
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
